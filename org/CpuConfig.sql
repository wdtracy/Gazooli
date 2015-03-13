/*
Get the SQL Information for your 
server. 
*NOTE SQL cannot tell the difference between physical 
and hyperthreaded cores
*/
SELECT 
	cpu_count AS [Logical CPU Count]
	,hyperthread_ratio AS [Hyperthread Ratio]
	,cpu_count/hyperthread_ratio AS [Physical CPU Count]
	,physical_memory_kb/1048576 AS [Physical Memory (MB)]
	,scheduler_count
	,sqlserver_start_time 
	,affinity_type_desc 
FROM 
	sys.dm_os_sys_info 
		OPTION (RECOMPILE);
