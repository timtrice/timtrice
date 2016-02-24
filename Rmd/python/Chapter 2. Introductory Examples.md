
## usa.gov data from bit.ly


```python
path = "../../../pydata-book/ch02/usagov_bitly_data2012-03-16-1331923249.txt"
```


```python
open(path).readline()
```




    '{ "a": "Mozilla\\/5.0 (Windows NT 6.1; WOW64) AppleWebKit\\/535.11 (KHTML, like Gecko) Chrome\\/17.0.963.78 Safari\\/535.11", "c": "US", "nk": 1, "tz": "America\\/New_York", "gr": "MA", "g": "A6qOVH", "h": "wfLQtf", "l": "orofrog", "al": "en-US,en;q=0.8", "hh": "1.usa.gov", "r": "http:\\/\\/www.facebook.com\\/l\\/7AQEFzjSi\\/1.usa.gov\\/wfLQtf", "u": "http:\\/\\/www.ncbi.nlm.nih.gov\\/pubmed\\/22415991", "t": 1331923247, "hc": 1331822918, "cy": "Danvers", "ll": [ 42.576698, -70.954903 ] }\n'




```python
import json
records = [json.loads(line) for line in open(path, "rb")]
```

The line above is called *list comprehension* which is a concise way of applying an operation to a collection of strings or other objects. 


```python
records[0]
```




    {u'a': u'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.78 Safari/535.11',
     u'al': u'en-US,en;q=0.8',
     u'c': u'US',
     u'cy': u'Danvers',
     u'g': u'A6qOVH',
     u'gr': u'MA',
     u'h': u'wfLQtf',
     u'hc': 1331822918,
     u'hh': u'1.usa.gov',
     u'l': u'orofrog',
     u'll': [42.576698, -70.954903],
     u'nk': 1,
     u'r': u'http://www.facebook.com/l/7AQEFzjSi/1.usa.gov/wfLQtf',
     u't': 1331923247,
     u'tz': u'America/New_York',
     u'u': u'http://www.ncbi.nlm.nih.gov/pubmed/22415991'}



Each "row' above is a column of data similar to the output in **R** when calling `str()`. So, if we wanted to access the first row of column `tz`, we call:


```python
records[0]["tz"]
```




    u'America/New_York'



The `u` at the beginning of the string stands for unicode noting the string encoding. If we just want the result we can do `print()`:


```python
print(records[0]["tz"])
```

    America/New_York
    

## Counting Time Zones in Pure Python

Let's extract a list of the timezones:

This error is saying that not all records have a `tz` field. To overcome this, we have to add an `if` statement to our loop:


```python
time_zones = [rec["tz"] for rec in records if "tz" in rec]
time_zones[:10]
```




    [u'America/New_York',
     u'America/Denver',
     u'America/New_York',
     u'America/Sao_Paulo',
     u'America/New_York',
     u'America/New_York',
     u'Europe/Warsaw',
     u'',
     u'',
     u'']



Where some strings are empty is our values that did not have a `tz` field.

To count the ten most common `tz` we can import the **Collections** library and use `Counter`


```python
from collections import Counter
counts = Counter(time_zones)
counts.most_common(10)
```




    [(u'America/New_York', 1251),
     (u'', 521),
     (u'America/Chicago', 400),
     (u'America/Los_Angeles', 382),
     (u'America/Denver', 191),
     (u'Europe/London', 74),
     (u'Asia/Tokyo', 37),
     (u'Pacific/Honolulu', 36),
     (u'Europe/Madrid', 35),
     (u'America/Sao_Paulo', 33)]



## Counting Time Zones with pandas


```python
from pandas import DataFrame, Series
import pandas as pd
frame = DataFrame(records)
frame.info()
```

    <class 'pandas.core.frame.DataFrame'>
    Int64Index: 3560 entries, 0 to 3559
    Data columns (total 18 columns):
    _heartbeat_    120 non-null float64
    a              3440 non-null object
    al             3094 non-null object
    c              2919 non-null object
    cy             2919 non-null object
    g              3440 non-null object
    gr             2919 non-null object
    h              3440 non-null object
    hc             3440 non-null float64
    hh             3440 non-null object
    kw             93 non-null object
    l              3440 non-null object
    ll             2919 non-null object
    nk             3440 non-null float64
    r              3440 non-null object
    t              3440 non-null float64
    tz             3440 non-null object
    u              3440 non-null object
    dtypes: float64(4), object(14)
    memory usage: 333.8+ KB
    


```python
frame["tz"][:10]
```




    0     America/New_York
    1       America/Denver
    2     America/New_York
    3    America/Sao_Paulo
    4     America/New_York
    5     America/New_York
    6        Europe/Warsaw
    7                     
    8                     
    9                     
    Name: tz, dtype: object




```python
tz_counts = frame["tz"].value_counts()
tz_counts[:10]
```




    America/New_York       1251
                            521
    America/Chicago         400
    America/Los_Angeles     382
    America/Denver          191
    Europe/London            74
    Asia/Tokyo               37
    Pacific/Honolulu         36
    Europe/Madrid            35
    America/Sao_Paulo        33
    Name: tz, dtype: int64



We have 521 records of missing data. 


```python
clean_tz = frame["tz"].fillna("Missing")
clean_tz[clean_tz == ""] = "Unknown"
tz_counts = clean_tz.value_counts()
tz_counts[:10]
```




    America/New_York       1251
    Unknown                 521
    America/Chicago         400
    America/Los_Angeles     382
    America/Denver          191
    Missing                 120
    Europe/London            74
    Asia/Tokyo               37
    Pacific/Honolulu         36
    Europe/Madrid            35
    Name: tz, dtype: int64




```python
tz_counts[:10].plot(kind = "barh", rot = 0)
```




    <matplotlib.axes._subplots.AxesSubplot at 0x8014ed0>




```python
frame["a"][1]
```




    u'GoogleMaps/RochesterNY'




```python

```
