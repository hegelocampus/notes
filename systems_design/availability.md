# Availability
- System fault tolerance - How resistant a system is to failures.
- The amount if time in a year, as a percentage, that the system is able to satisfy its requirements.
- Modern systems have an almost implied guarantee of availability. But there are still degrees to which availability is important. For example, a database that powers a hospital or an airplane would have to have better availability than someone's blog.
  - The more popular your service the better the availability is expected to be. For example, Google going down would be a very very big deal.
## How do you measure availability
- Typically measured as the percentage of a year that the system is up and functioning.
  - It's often referred to as "nines" if your system has 90% availability it's said to have "one nine", 99% availability is "two nines", 99.9% is "three nines" and so on.
  - 99% availability is still 3.65 days of downtime a year. Five nines is regarded as the gold standard of availability, which is 99.999% availability, or 5.26 minutes of downtime per year.
## SLA/SLO
- SLA - Service Level Agreement
  - Many service providers have these agreements which agree a certain percentage of availability
  - These tend to contain clauses explaining what will happen if the provider does not meet the SLO's of the agreement.
- SLO - Service Level Objective
  - Although this is often used synonymously with SLA, it is actually the individual components within an SLA, it is the specific clauses of the agreement.
## How to improve Availability
- Look for single points of failure and add redundancy, one way of doing this is by adding additional serves.
  - Adding additional servers will probably require a load balancer. This will now likely be your single point of failure. So you can increase your number of load balancers.
- Simply adding more servers is known as **passive redundancy**. This is because a server can fail and the entire system will still run.
- **Active redundancy** is a little more complicated, it requires having a network of machines that uses monitoring so that it can tell if one of the machines is down and take over its processing. An example is a Kubernetes cluster.
