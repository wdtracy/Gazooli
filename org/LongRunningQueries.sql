
--SQL SNIPPET - LIST MOST EXPENSIVE QUERIES USED ON Server
USE master;
GO
SELECT TOP 50
            DB_NAME(DB_ID()) AS Database_Name,
            SUBSTRING(qt.TEXT, (qs.statement_start_offset/2)+1,
        ((CASE qs.statement_end_offset
                            WHEN -1 THEN DATALENGTH(qt.TEXT)
                ELSE qs.statement_end_offset
                END - qs.statement_start_offset)/2)+1) AS Query_Text,
            qs.execution_count,
            qs.total_worker_time/1000 total_worker_time_in_ms,
            qs.last_worker_time/1000 last_worker_time_in_ms,
            qs.total_elapsed_time/1000 total_elapsed_time_in_ms,
            qs.last_elapsed_time/1000 last_elapsed_time_in_ms,
            qs.total_worker_time/execution_count/1000 AS avg_worker_time_in_ms,
            qs.total_logical_reads, qs.last_logical_reads,
            qs.total_logical_writes, qs.last_logical_writes,
            qs.last_execution_time
            -- qp.query_plan
    FROM sys.dm_exec_query_stats qs
            CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
            CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
    -- ORDER BY qs.total_logical_reads DESC; -- logical reads
    -- ORDER BY qs.total_logical_writes DESC; -- logical writes
    ORDER BY qs.total_worker_time DESC; -- CPU time
GO
