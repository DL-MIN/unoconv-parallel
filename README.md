# Unoconv Parallel

Run multiple instances of unoconv in parallel. Especially useful in Moodle applications.


## Requirements

- unoconv (>= 0.9.0)
- bash


## Install

1.  Clone repository

    ```
    $ git clone git@github.com:DL-MIN/unoconv-parallel.git /opt/unoconv-parallel
    ```
2.  Set permissions

    ```
    chmod +x /opt/unoconv-parallel/unoconv-parallel.sh
    ```

3.  Configure Moodle

    `pathtounoconv` set to `/opt/unoconv-parallel/unoconv-parallel.sh`


## Configuration

The script `unoconv-parallel.sh` contains a configuration section in the beginning.

| Variable            | Default                  | Comments                                                                          |
|:--------------------|:-------------------------|:----------------------------------------------------------------------------------|
| $unoconv_path       | `/usr/local/bin/unoconv` | Path to your unoconv executable                                                   |
| $unoconv_max_time   | 30s                      | Maximum runtime of unoconv to terminate zombie processes                          |
| $unoconv_tmp_dir    | `/tmp`                   | Path for temporary user profiles                                                  |
| $unoconv_port_range | 2000-2999                | TCP port range which can be used by unoconv for its server-client-architecture    |
| $unoconv_max_retry  | 5                        | Ports are picked randomly; how many retries are allowed in the case of conflicts? |
