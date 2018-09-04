# Application Exercice

In order to test your knowledge, we ask you to solve this basic problem

Clone this repository, run the spec and write the code that makes all the tests succeed !


**Notes :**

* The name of the models are taken from french so to give you a better understanding, a Commune is equivalent to a City.

* How to run the spec ? That's part of the test, do it yourself !

* Don't write in the `spec` directory, that would be cheating !

* Don't fork the repository to not share the response with others.

* When you finish, send the URL of your repository.

**I have some explanations :**
* For checking doublons job run in twice, I have to create jobs db table to track it since I used to ActiveJob. If I use Sidekiq gem as old rails version, I can get all jobs in queue, and compare arguments directly on sidekiq jobs, don't need to create local jobs tables.
