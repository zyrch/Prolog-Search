import pandas as pd

df = pd.read_excel('../roaddistance.xlsx')

df = df.drop('Road Distance of  Major  Cities', axis=1)
df.columns = df.iloc[0]
df = df.drop(df.index[0])

f = open('../src/knowledgeBase.pl', 'w')

for i in range(len(df)):
    start_city = df[df.columns[0]].iloc[i]
    start_city = start_city.lower()
    for j in df.columns[1:]:
        distance = df[j].iloc[i]
        if distance == '-':
            continue
        end_city = j.lower()
        f.write(f'connect({start_city}, {end_city}, {distance}).\n')
        f.write(f'connect({end_city}, {start_city}, {distance}).\n')

f.close()
