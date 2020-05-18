SELECT
        o.name AS Table_Name
       ,i.name AS Index_Name
       ,STATS_DATE(o.id, i.indid) AS Date_Updated
FROM
        sysobjects o 
        JOIN sysindexes i ON i.id = o.id
WHERE
        xtype = 'U'
        AND i.name IS NOT NULL
ORDER BY
      Date_Updated
      --o.name ASC
      --,i.name ASC
Test
