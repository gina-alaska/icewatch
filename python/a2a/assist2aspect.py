
from pandas import read_csv
import numpy as np
import StringIO


def format_topo_data ( topo ):
    """clean up the types of the topography data
    
    Parameters
    ----------
    topo: Dataframe
        Dataframe with text columns ['PTop','PTopC','PRH','POld','PCs','PSC',
        'STop','STopC','SRH','SOld','SCs','SSC',
        'TTop','TTopC','TRH','TOld','TCs','TSC']
    
    Returns
    -------
    Dataframe
        Same columns as input but with columns types converted from text
        to types used in aspect to assist topography conversion
    """
    float_cols = ['PRH',   'SRH',   'TRH']
    for col in float_cols:
        topo[col] = topo[col].astype(float)
        
    int_cols = [ 'PTop',  'STop',  'TTop', 'PTopC', 'STopC', 'TTopC',]
    int_clean = lambda x: int(x) if str(x) != 'nan' else 0
    for col in int_cols:
        topo[col] = topo[col].map(int_clean)
        
    bool_cols = [
        'POld','PCs','PSC',
        'SOld','SCs','SSC',
        'TOld','TCs','TSC',
    ]
    
    for cols in [('POld','PCs'), ('SOld','SCs'), ('TOld','TCs')]:
        index = topo[cols[0]].map(lambda s: str(s).lower()) == 'true'
        topo[cols[1]][index] = 'TRUE'
    
    def bool_clean(x):
        if str(x).lower() == 'true':
            return '1' # true 
        elif str(x).lower() == 'false':
            return '0' # false
        else:
            return '9' # n/a
            
    
    #~ bool_clean = lambda x: bool(x) if str(x) != 'nan' else False
    for col in bool_cols:
        topo[col] = topo[col].map(bool_clean)
    
    return topo
    
def create_aspect_topo_code (topo_data):
    """Create the aspect topography codes for a single set of topogaphry 
    coumns from assist
    
    Parameters
    ----------
    topo_data: Dataframe
        Dataframe with columns ['TopC', 'Top', 'RH','Old','Cs','SC']
        
    Returns
    -------
    Series
        column of Aspect codes for topography
    """
    # 'x' 
    topo_data['x'] = topo_data['TopC'] * 10
    
    # 'y'
    def get_y_code(y):
        if y == .5:
            return 1
        elif y == 1:
            return 2
        elif y == 1.5:
            return 3
        elif y in [2,2.5]:
            return 4
        elif y in [3,3.5]:
            return 5
        elif y in [4,4.5]:
            return 6
        else:
            return 7
    topo_data['y'] = 0
    topo_data['y'][topo_data['Top'] == 500] = \
        topo_data['RH'][topo_data['Top'] == 500].map(get_y_code)
    
    # 500 -> n00
    #(old, consolidated, snow covered)
    bool_map = {
        '000': 500, #(False, False, False)
        '001': 600, #(False, False, True)
        '011': 700, #(False, True,  True)
        '010': 700, #(False, True,   False) # not in aspect
        '019': 700, #(False, True, N/a)
        '100': 800, #(True,  False, False) # not in aspect
        '101': 800, #(True,  False,  True), # not in aspect
        '110': 800, #(True,  True,  False) 
        '111': 800, #(True,  True,  True)
        '190': 800, #(True,  N/a,  False), 
        '191': 800, #(True,  N/a,  True), 
       
    }
    b_cols = ['Old','Cs','SC']
    topo_data['code'] = [
        ''.join(x) for x in  list(
            topo_data[b_cols].astype(int).astype(str).values
        )
    ]
    
    #~ get_code = lambda x: bool_map[x]
    def get_code (x):
        try: 
            return bool_map[x]
        except KeyError:
            return np.nan
    topo_data['code'][topo_data['Top'] != 500] = \
        topo_data['Top'][topo_data['Top'] != 500]
    topo_data['code'][topo_data['Top'] == 500] = \
        topo_data['code'][topo_data['Top'] == 500].map(get_code)
    
    topo_data['code'] = topo_data['code'] + topo_data['x'] + topo_data['y']
    
    topo_data['code'][topo_data['code'] == 0] = np.nan
    
    return topo_data['code']
    
    
    

def assist2aspect ( assist ):
    """Convert assist v4 to ASPeCT v3
    
    Parametes 
    ---------
    Assist: DataFrame
        assist data as read for Assist v4 csv file
        
    Returns 
    -------
    Dataframe
        Aspect v3 Dataframe
    """
    ## columns in assist that are in aspect
    assist_aspect_cols = [ 
        'Date', 'LAT', 'LON', 
        'TC','PPC','PT','PZ','PF','PTop','PSY','PSH','PA','PMPC',
        'PMPD','SPC','ST','SZ','SF','STop','SSY','SSH','SA',
        'SMPC','SMPD','TPC','TT','TZ','TF','TTop','TSY','TSH',
        'TA','TMPC','TMPD','OW','WT','AT','WS','WD','TCC','V',
        'WX','PO', 'AO','Comments'
    ]
    ## columns used in constructing the topography feild in assist
    topo_cols = [
        'PTop','PTopC','PRH','POld','PCs','PSC',
        'STop','STopC','SRH','SOld','SCs','SSC',
        'TTop','TTopC','TRH','TOld','TCs','TSC',
    ]
    topo_data = assist[ topo_cols ]
    topo_data = format_topo_data( topo_data )
    
    # brown ice columns
    bi_data = assist[['PA', 'PAL', 'SA', 'SAL', 'TA', 'TAL']]
    
    # get aspect columns from assist and rename to aspect names
    aspect = assist[ assist_aspect_cols ]
    #~ aspect = aspect.astype(str)
    aspect.columns = [
        'Date', 'Latitude', 'Longitude', 
        'T/Conc', 'c1', 'ty1', 'z1', 'f1', 'to1', 'Sty1', 'Sz1', 'BI1', 'MPc1',
        'MPd1', 'c2', 'ty2', 'z2', 's2', 'to2', 'Sty2', 'Sz2', 'BI2',
        'MPc2', 'MPd2', 'c3', 'ty3', 'z3', 'f3', 'to3', 'Sty3', 'Sz3',
        'BI3', 'MPc3', 'MPd3', 'O/W', 'Water Temp', 'Air Temp', 
        'Wind speed [m/s]','Wind Dir. [deg]','Cloud [_/8]','Vis',
        'WW', 'PO', 'AO', 'Comments'
    ]
    # split out time and date
    aspect['Time'] = aspect['Date'].map(lambda d: str(d).strip().split(' ')[1])
    aspect['Time'] = aspect['Time'].map(
        lambda d: str(
            int(d.split(':')[0]) + (1 if int(d.split(':')[1]) >= 30 else 0)
            )
        )
    aspect['Date'] = aspect['Date'].map(lambda d: str(d).strip().split(' ')[0])
    
    # add columns not in assist
    not_in_assist = ['MPl11', 'MPl21', 'MPl12', 'MPl22', 'MPl13', 'MPl23']
    for key in not_in_assist:
        aspect [key] = None
    
    # Ice Types
    for key in ['ty1', 'ty2', 'ty3']:
        aspect [aspect[key] == '75'][key] = '85'
        
    
    #~ # Floe sizes: this is a direct conversion 
    #~ convert = ['f1', 'f2', 'f3']
    
    # Topography 
    for col in [('P','to1'), ('S','to2'), ('T','to3')]:
        temp = topo_data[[c for c in topo_data.columns if c[0] == col[0]]]
        temp.columns = ['Top','TopC','RH','Old','Cs','SC',]
        aspect[col[1]] = create_aspect_topo_code(temp)
         
    
    # Algea -> brown ice
    ## use concentration and location to crate single aspect code
    for col in [('P','BI1'),('S','BI2'),('T','BI3')]:
        temp = bi_data[[c for c in bi_data.columns if c[0] == col[0]]]
        temp.columns = ['A', 'AL']
        aspect[col[1]] = ''
        aspect[col[1]][temp['A'] == '0'] = "'0'"
        
        for loc in [('10',"'d00'"), ('20',"'0d0'"), ('30',"'00d'")]:
            index = np.logical_and(
                np.logical_or(temp['A'] != '', temp['A'] != '0'),
                temp['AL'] == loc[0]
            )
            aspect[col[1]][index] = \
                temp['A'][index].map(lambda d: loc[1].replace('d',d))
            
            
    
    
    
     
    # Wind speed convert to m/s
    aspect['Wind speed [m/s]'] = \
        aspect['Wind speed [m/s]'].astype(float) * .514 # knots * ([m/s]/knots) 
        
    # Format weather codes
    #~ aspect['WW'] = aspect['WW'].map(lambda x: str(x).replace('nan',''))
    aspect['WW'] = aspect['WW'].map(lambda x: '{:02d}'.format(int(x)) if str(x) != 'nan' else '')
    
    aspect['AO'][ aspect['AO'].map(lambda x: str(x).lower()) == 'nan'] = ''
    aspect['Observer'] = aspect['PO'] + \
        aspect['AO'].map(lambda o:  ':'+ str(o) if len(str(o)) > 0 else str(o))
    
    
    aspect['Flag1'] = ''
    aspect['Flag2'] = ''
    aspect['Flag3'] = ''
    # aspect columns in corret order
    sorted_aspect_cols = [ 
        'Date', 'Time', 'Latitude', 'Longitude', 
        'T/Conc','c1','ty1','z1','f1','to1','Sty1','Sz1','BI1','MPc1','MPd1',
        'MPl11','MPl21','c2','ty2','z2','s2','to2','Sty2','Sz2','BI2','MPc2',
        'MPd2','MPl12','MPl22','c3','ty3','z3','f3','to3','Sty3','Sz3','BI3',
        'MPc3','MPd3','MPl13','MPl23','O/W','Water Temp','Air Temp',
        'Wind speed [m/s]','Wind Dir. [deg]','Cloud [_/8]','Vis',
        'WW', 'Flag1', 'Flag2', 'Flag3','Observer','Comments'
    ]

    ## TEMP
    return  aspect[sorted_aspect_cols]
  
  
def str2str (assist_string):
    #~ return str(type(assist_string))
    assist_io = StringIO.StringIO(assist_string)

    assist = read_csv(assist_io, dtype=str)
    aspect = assist2aspect( assist )
    #~ return 'here'
    aspect.columns = [
        'Date', 'Time', 'Latitude', 'Longitude', 'Conc.',
        'c','ty','z','f','txy','S','sz','bi','mc','mz', 'ml1','ml2',
        'c','ty','z','f','txy','S','sz','bi','mc','mz', 'ml1','ml2',
        'c','ty','z','f','txy','S','sz','bi','mc','mz', 'ml1','ml2',
        
        'O/W','Tw','Ta',
        'Speed', 'Dir.','Cloud', 'Vis',
        'Weather', 'Flag1','Flag2','Flag3','Observer','Comments'
    ]
    
    #convert to csv string and return
    aspect_io = StringIO.StringIO()
    aspect.to_csv(aspect_io, index = False)
    aspect = aspect_io.getvalue()
    aspect_io.close()
   
    aspect = 'Date,Hr,Latitude,Longitude,Total,' + 'Primary,' * 12 + \
        'Secondary,' * 12 + 'Tertiary,' * 12 + \
        ',,,Wind,Wind,,,,Quality,Quality,Quality,,\n' + aspect
    return aspect
    
    
