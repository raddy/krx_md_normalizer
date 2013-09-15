import sys,os
import pandas as pd
from krx_normalize import two_level_fix_a3s


def fix_a3s(file_name):
    store = pd.HDFStore(file_name)
    dat = store['pcap_data']
    newdat = two_level_fix_a3s(dat.symbol,dat.msg_type.str[1:].astype(long),dat.ix[:,['bid1','bidsize1','ask1','asksize1','bid2','bidsize2','ask2','asksize2','tradeprice','tradesize']].values)
    dat[['bid1','bidsize1','ask1','asksize1','bid2','bidsize2','ask2','asksize2','tradeprice','tradesize']] = pd.DataFrame(newdat,columns = ['bid1','bidsize1','ask1','asksize1','bid2','bidsize2','ask2','asksize2','tradeprice','tradesize'], index = dat.index)
    store['pcap_data'] = dat
    store.close()

def main(file_name):
    print 'Modifying the following %s ....' %file_name
    fix_a3s(file_name)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit('Usage: %s tcp pcap-path' % sys.argv[0])

    if not os.path.exists(sys.argv[1]):
        sys.exit('ERROR: Raw Pcap file %s was not found!' % sys.argv[1])
    sys.exit(main(sys.argv[1]))