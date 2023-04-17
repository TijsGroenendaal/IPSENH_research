# IPSENH Research
I want to measure the difference in query speed based on the combination in `work_mem` and `max_parallel_workers_per_gather`.

## Configuration files
In the `config` folder are the configuration files for the postgresql server. The configuration files are based on the [official documentation](https://www.postgresql.org/docs/12/runtime-config-resource.html).
- The max_parallel_workers are set to 34.
- The max_worker_processes are set to 34.
- The shared buffers are set to 1024MB (Which is 25% of the system memory).
- The file names are based on the amount of workers and the amount of memory per worker.
  - 2w_32000kb.conf
    - 2 workers | 32000kb memory per worker
  - 4w_16000kb.conf
    - 4 workers | 16000kb memory per worker



## Protecting environment:
- For each new sample set the postgresql server should be restarted
  - Each configuration file
  - Each query (Not sample in query)
- Same base operating system.
- Same postgresql version
- Configuration allowed to edit
  - `shared_buffers` (Shared memory between workers) 
  - `max_parallel_workers_per_gather` (Max parallel workers per query)
  - `work_mem` (Max memory per operation)
  - `max_worker_processes` (Maximum background processes)
  - `max_parallel_workers` (Parallel workers from the pool of worker processes)


## Query scenarios
For the queries a theoretical scenario will be used where in we want to keep track of the liveliness of each container.

The queries are based on a theoretical analyses dashboard. 

- Seconds a container has been down in the past N days (31 days)
- Percentage a container has been in down in the past N days (31 days)
- Seconds each container in a resource group has been down in the past N days (31 days)
- Percentage each container in a resource group has been down in the past N days (31 days)
- Timeseries of a container
- Timeseries of a resource group.

In the database the following data is stored:

10 resource groups of each 10 containers. Each container has a timeseries of 535.680 points with an interval of 10 seconds. 2 percent of the timeseries has a status false.
Total rows -> 53.568.000


### Timeseries

| property | datatype  | example                                | description                          |
|:---------|:----------|:---------------------------------------|:-------------------------------------|
| id       | uuid      | '6a8bf646-40c3-498e-a411-075ae3232860' |                                      |
| datatime | timestamp | '2022--06-06 22:00:00.000000'          | Interval of N seconds                |
| status   | boolean   | 0 (false), 1 (true)                    |                                      |
| resource | int       | 1                                      | Reference to [`Resource`](#resource) |

### Resource

| property | datatype | example | description                                      | 
|:---------|:---------|:--------|:-------------------------------------------------|
| id       | int      | 1001    | `r_group` multiplied by 1000 + iteration         |
| r_group  | int      | 1       | reference to [`Resource Group`](#resource-group) |

### Resource Group

| property | datatype | example | description | 
|:---------|:---------|:--------|:------------|
| id       | int      | 1       |             |