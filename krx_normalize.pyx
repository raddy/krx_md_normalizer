import numpy as np
import pandas as pd
import sys
cimport cython
cimport numpy as np

#first pass one symbol at a time
#data should be a 2d array of LONGS
#bid1,bidsize1,ask1,asksize1,bid2,bidsize2,ask2,asksize2,tradeprice,tradesize
# 0  ,  1      , 2,   3 ,      4,     5 ,   6,     7,         8,       9
@cython.cdivision(True)
@cython.boundscheck(False)
def two_level_fix_a3s(np.ndarray[object,ndim=1] symbols,np.ndarray[long,ndim=1] msg_types,np.ndarray[long, ndim=2] data):
    
    assert(symbols.shape[0] == data.shape[0])
    assert(data.shape[1] == 10)

    cdef:
        dict last_info = {}
        int a3_count = 0
        int a3_violations = 0
        long tradeprice,tradesize
    for i in range(0,symbols.shape[0]):
        if msg_types[i] == 3:
            a3_count+=1
            if not last_info.has_key(symbols[i]):
                a3_violations+=1
                continue
            if data[i,8] == last_info[symbols[i]][0]: #if the A3 price equals previous bid price
                #SHIFT BIDS
                data[i,] = [last_info[symbols[i]][4],last_info[symbols[i]][5],last_info[symbols[i]][0],0,
                            -1,-1,last_info[symbols[i]][2],last_info[symbols[i]][3],data[i,8],data[i,9]]
            elif data[i,8] == last_info[symbols[i]][2]: #if the A3 price equals previous ask price
                #SHIFT ASKS
                data[i,] = [last_info[symbols[i]][2],0,last_info[symbols[i]][6],last_info[symbols[i]][7],
                            last_info[symbols[i]][0],last_info[symbols[i]][1],-1,-1,data[i,8],data[i,9]]
            else:
                #shit yourself
                a3_violations+=1
                tradeprice = data[i,8]
                tradesize = data[i,9]
                data[i,] = last_info[symbols[i]]
                data[i,8] = tradeprice
                data[i,9] = tradesize
            last_info[symbols[i]] = data[i,]
        else:
            last_info[symbols[i]] = data[i,]
    print 'Total A3 Messages: ', a3_count, ' || Number of A3 Assumption Violations: ', a3_violations
    return data