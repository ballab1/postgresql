# postgres

About this Repo

This is a copy of the 'postgres/10/alpine/' folder from the Git repo of the Docker [official image](https://docs.docker.com/docker-hub/official_repos/) for [postgres](https://registry.hub.docker.com/_/postgres/). See [the Docker Hub page](https://registry.hub.docker.com/_/postgres/) for the full readme on how to use this Docker image and for information regarding contributing and issues.

---

based on standard container:  [postgres](https://hub.docker.com/_/postgres)
additions:
* [quantile](https://github.com/tvondra/quantile) v1.1.2   an aggregation function for PostgreSQL
* [timescaledb](https://github.com/timescale/timescaledb/) v0.7.1   An open-source time-series database optimized for fast ingest and complex queries. Engineered up from PostgreSQL, packaged as an extension. [website](http://www.timescale.com/)


to build & run
```bash
 docker build --tag postgres --rm=true https://eos2git.cec.lab.emc.com/DevEnablement/PostgreSQL_Container.git
 mkdir data
 chown postgres:postgres data
 docker run --name postgres -p 5432:5432 -v $PWD/data:/var/lib/pgsql/data -d postgres:latest
```

