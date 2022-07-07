   CREATE OR REPLACE FUNCTION test_st_ch(int,int)
            RETURNS TABLE(f1 text, f2 text,f3 float,f4 float,f5 float) AS
   $BODY$
          SELECT 
(select host FROM hosts where hostid = i.hostid) as host_name,
i.name,
ROUND(min(value)/1024/1024/1024,2) as MIN,
ROUND(avg(value)/1024/1024/1024,2) as AVG,
ROUND(max(value)/1024/1024/1024,2) as MAX
FROM public.history_uint u join public.items i on i.itemid = u.itemid where i.hostid in 
(SELECT hostid FROM hosts where host in ('ASUGF-WEB101P','ASUGF-APP101P',
                                         'ASUGF-DBS102P','ASUGF-APP301P','ASUGF-DBS302P',
                                         'ASUGF-BPM301P','ASUGF-DBS001P','ASUGF-WEB501P','ASUGF-DBS501P')) 
and (i.name = 'Available memory' or i.name = 'Memory usage' )
and clock >= $1 and clock <= $2
group by host_name, i.name

union all

SELECT 
(select host FROM hosts where hostid = i.hostid) as host_name,
i.name,
ROUND(min(value)/1024/1024/1024,2) as MIN,
ROUND(avg(value)/1024/1024/1024,2) as AVG,
ROUND(max(value)/1024/1024/1024,2) as MAX
FROM public.history u join public.items i on i.itemid = u.itemid where i.hostid in 
(SELECT hostid FROM hosts where host in ('ASUGF-APP001P','ASUGF-WEB001P','ASUGF-WEB701P','ASUGF-DBS701P'
                                        ,'ASUGF-WEB601P','ASUGF-DBS601P','ASUGF-WEB801P','ASUGF-DBS801P')) 
and i.name = 'Memory usage' and clock >= $1 and clock <= $2
group by host_name, i.name

union all

SELECT 
(select host FROM hosts where hostid = i.hostid) as host_name,
i.name,
ROUND(min(value),5) as MIN,
ROUND(avg(value),5) as AVG,
ROUND(max(value),5) as MAX
FROM public.history u join public.items i on i.itemid = u.itemid where i.hostid in 
(SELECT hostid FROM hosts where host in ('ASUGF-WEB101P','ASUGF-APP101P',
                                         'ASUGF-DBS102P','ASUGF-APP301P','ASUGF-DBS302P',
                                         'ASUGF-BPM301P','ASUGF-DBS001P','ASUGF-WEB501P','ASUGF-DBS501P','ASUGF-APP001P','ASUGF-WEB001P','ASUGF-WEB701P','ASUGF-DBS701P'
                                        ,'ASUGF-WEB601P','ASUGF-DBS601P','ASUGF-WEB801P','ASUGF-DBS801P')) 
and i.name like 'Processor load (1 min%' and clock >= $1 and clock <= $2
group by host_name, i.name

union all

SELECT 
(select host FROM hosts where hostid = i.hostid) as host_name,
i.name,
ROUND(min(value)/1024/1024,2) as MIN,
ROUND(avg(value)/1024/1024,2) as AVG,
ROUND(max(value)/1024/1024,2) as MAX
FROM public.history_uint u join public.items i on i.itemid = u.itemid where i.hostid in 
(SELECT hostid FROM hosts where host in ('ASUGF-NLB001P')) 
and i.name like 'Outgoing network traffic on ens256' and clock >= $1 and clock <= $2
group by host_name, i.name

union all

SELECT 
(select host FROM hosts where hostid = i.hostid) as host_name,
i.name,
ROUND(min(value)/1024/1024,2) as MIN,
ROUND(avg(value)/1024/1024,2) as AVG,
ROUND(max(value)/1024/1024,2) as MAX
FROM public.history_uint u join public.items i on i.itemid = u.itemid where i.hostid in 
(SELECT hostid FROM hosts where host in ('ASUGF-NLB001P')) 
and i.name like 'Incoming network traffic on ens256' and clock >= $1 and clock <= $2
group by host_name, i.name

order by host_name;

   $BODY$
        LANGUAGE 'sql' VOLATILE;
