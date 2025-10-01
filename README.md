# ZFShotter

ZFShotter is a utility designed to automate the creation of ZFS snapshots and
replicate them to remote servers


## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Configuration](#configuration)
  - [Job](#job)
  - [Datasets](#datasets)
  - [Replication](#replication)
- [License](#license)


## Features

- Automates the creation of ZFS snapshots.
- Flexible prune policy pipeline to automate the pruning of old snapshots.
- Supports replication of snapshots to remote servers (push-based via ssh).
- Easy configuration file for customizable settings.


## Installation

To install ZFShotter, follow these steps:

1. Clone the repository to your desired directory (e.g., `/opt/`, `/usr/local/`,
   or wherever you want). In this documentation, we will use `/usr/local`:

   ```bash
   git clone https://github.com/mojtabamoaddab/zfshotter.git /usr/local/zfshotter
   ```

2. Configure Jobs according configuration section.

3. Define a job scheduler (e.g., cron or systemd-timer) to run the jobs with following command:

   ```bash
   /usr/local/zfshotter/bin/zfshotter.sh <JOB_NAME>
   ```

## Configuration

The configuration for ZFShotter is organized into a `config` directory,
which contains three subdirectories: `jobs`, `datasets`, and `replications`.
Each subdirectory holds `.conf` files that define the respective configurations.


### Directory Structure

```
config/
├── jobs/
│   └── sample.conf
├── datasets/
│   └── sample.conf
└── replications/
    └── sample.conf
```


### Job

A job is a sequence of operations that involves taking snapshots, pruning old ones,
and then replicating them.

You can see `config/jobs/sample.conf` to possible configuration options.

Supported prune-policies (can be combined with `|`):

| Prune Policy          | Description                              | Example                |
|-----------------------|------------------------------------------|------------------------|
| `keep_for <duration>` | Keep snapshots within specified duration | `keep_for 4d12h`       |
| `keep_n <n>`          | Keep the last n snapshots                | `keep_n 20`            |
| `keep_regex <regex>`  | Keep snapshots that match the specified regex pattern in their name | `keep_regex "^manual"` |


### Datasets

The datasets configuration file is a simple list of datasets  (for taking snapshots,
pruning, or replicating) along with some per-dataset options.
Each line contains a dataset path followed by optional key-value pairs separated by semicolons.

Example:
```
path/to/dataset; option1=value1; option2=value2
```


### Replication

This section defines the remote server for replicating snapshots and the datasets to replicate.

You can see `config/replications/sample.conf` to possible configuration options.



## License

This project is licensed under the GPL-3.0-or-later License -
see the `COPYING` file for details.
