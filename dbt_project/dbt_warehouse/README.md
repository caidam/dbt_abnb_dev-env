### Health check

Don't forget to cd into the dbt project before running the commands
- cd dbt_warehouse
- dbt debug
- if issues with dbt power user ctrl shift p select python interpreter

### Good to know

- use function md5(column1 || column2) to create surrogate keys

### Using the starter project

Try running the following commands:
- dbt run
- dbt test

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices


version 2

sources:
  - name: abnb_datawarehouse
    description: raw import from the result of the scraping script
    schema: raw
    tables:
      - name: listings