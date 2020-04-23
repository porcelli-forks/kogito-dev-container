# Kogito development image

This container image provides you with a quick starting point for building your Kogito project by only adding the necessary resource files like DMN or BPMN.

You don't need to bootstrap a new project, get maven, get graalvm, download all the dependencies, etc.

The image has:

* Graalvm-ce-java8-19.3.1
* Maven 3.6.3
* A bootstraped empty Kogito project
* Pre-loaded dependencies for your build

## Debug

First run the container by exposing the service and debug ports and mounting the resources folder:

```bash
$ podman run -it --rm -p 8080:8080 -p 5005:5005 -v `pwd`/examples:/home/kogito/src/main/resources:Z quay.io/ruben/kogito-dev:latest
[INFO] Scanning for projects...
[INFO] 
[INFO] ---------------------< org.kie.kogito:kogito-dev >----------------------
[INFO] Building kogito-dev 1.0.0-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ kogito-dev ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 1 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.8.1:compile (default-compile) @ kogito-dev ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] --- quarkus-maven-plugin:1.3.2.Final:dev (default-cli) @ kogito-dev ---
Listening for transport dt_socket at address: 5005
__  ____  __  _____   ___  __ ____  ______ 
 --/ __ \/ / / / _ | / _ \/ //_/ / / / __/ 
 -/ /_/ / /_/ / __ |/ , _/ ,< / /_/ /\ \   
--\___\_\____/_/ |_/_/|_/_/|_|\____/___/   
2020-04-23 00:03:18,832 WARN  [org.kie.kog.cod.GeneratorContext] (build-17) Unable to load 'application.properties'.
2020-04-23 00:03:20,591 INFO  [io.quarkus] (main) kogito-dev 1.0.0-SNAPSHOT (powered by Quarkus 1.3.2.Final) started in 2.066s. Listening on: http://0.0.0.0:8080
2020-04-23 00:03:20,593 INFO  [io.quarkus] (main) Profile dev activated. Live Coding activated.
2020-04-23 00:03:20,593 INFO  [io.quarkus] (main) Installed features: [cdi, kogito, resteasy, resteasy-jackson]
```

This example should enable you to debug and run your the service directly:

```bash
$ curl -H 'Accept: application/json' -H 'Content-Type: application/json' -d '{"Driver":{"Name":"Ruben", "Age": 1}}' http://localhost:8080/DriversCanDrive

{"Can drive":true,"Driver":{"Age":18,"Name":"Ruben"}}
```

You can also add more folders if needed or the whole project, but in this case I don't see much benefit in using this container image :-)

```bash
podman run -it --rm -p 8080:8080 -p 5005:5005 -v `pwd`/resources:/home/kogito/src/main/resources:Z -v `pwd`/java:/home/kogito/src/main/java quay.io/ruben/kogito-dev:latest
```

## Build

You can also build the either the jvm artifact or the native image by mounting the target directory. Make sure it is writable by all.

```bash
mkdir target
chmod a+w target
```

Now let's build the jar. Note that no dependencies were downloaded.

```bash
$ podman run -it --rm -v `pwd`/examples:/home/kogito/src/main/resources:Z -v `pwd`/target:/home/kogito/target:Z quay.io/ruben/kogito-dev:latest package
[INFO] Scanning for projects...
[INFO] 
[INFO] ---------------------< org.kie.kogito:kogito-dev >----------------------
[INFO] Building kogito-dev 1.0.0-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ kogito-dev ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 1 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.8.1:compile (default-compile) @ kogito-dev ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ kogito-dev ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory /home/kogito/src/test/resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.8.1:testCompile (default-testCompile) @ kogito-dev ---
[INFO] No sources to compile
[INFO] 
[INFO] --- maven-surefire-plugin:2.22.1:test (default-test) @ kogito-dev ---
[INFO] No tests to run.
[INFO] 
[INFO] --- maven-jar-plugin:2.4:jar (default-jar) @ kogito-dev ---
[INFO] 
[INFO] --- quarkus-maven-plugin:1.3.2.Final:build (default) @ kogito-dev ---
[INFO] [org.jboss.threads] JBoss Threads version 3.0.1.Final
[WARNING] Unable to load 'application.properties'.
[INFO] [io.quarkus.deployment.pkg.steps.JarResultBuildStep] Building thin jar: /home/kogito/target/kogito-dev-1.0.0-SNAPSHOT-runner.jar
[INFO] [io.quarkus.deployment.QuarkusAugmentor] Quarkus augmentation completed in 3074ms
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  5.509 s
[INFO] Finished at: 2020-04-23T00:02:09Z
[INFO] ------------------------------------------------------------------------

```

Or the native image

```bash
podman run -it --rm -v `pwd`/examples:/home/kogito/src/main/resources:Z -v `pwd`/target:/home/kogito/target:Z quay.io/ruben/kogito-dev:latest package -Pnative
```

Check the target folder for the resulting artifacts and try them out:

```bash
$ java -jar target/kogito-dev-1.0.0-SNAPSHOT-runner.jar
__  ____  __  _____   ___  __ ____  ______
 --/ __ \/ / / / _ | / _ \/ //_/ / / / __/
 -/ /_/ / /_/ / __ |/ , _/ ,< / /_/ /\ \
--\___\_\____/_/ |_/_/|_/_/|_|\____/___/
2020-04-23 01:49:13,689 INFO  [io.quarkus] (main) kogito-dev 1.0.0-SNAPSHOT (powered by Quarkus 1.3.2.Final) started in 0.911s. Listening on: http://0.0.0.0:8080
2020-04-23 01:49:13,692 INFO  [io.quarkus] (main) Profile prod activated.
2020-04-23 01:49:13,692 INFO  [io.quarkus] (main) Installed features: [cdi, kogito, resteasy, resteasy-jackson]
```

Or

```bash
$ ./target/kogito-dev-1.0.0-SNAPSHOT-runner
__  ____  __  _____   ___  __ ____  ______
 --/ __ \/ / / / _ | / _ \/ //_/ / / / __/
 -/ /_/ / /_/ / __ |/ , _/ ,< / /_/ /\ \
--\___\_\____/_/ |_/_/|_/_/|_|\____/___/
2020-04-22 23:48:47,985 INFO  [io.quarkus] (main) kogito-dev 1.0.0-SNAPSHOT (powered by Quarkus 1.3.2.Final) started in 0.010s. Listening on: http://0.0.0.0:8080
2020-04-22 23:48:47,985 INFO  [io.quarkus] (main) Profile prod activated.
2020-04-22 23:48:47,986 INFO  [io.quarkus] (main) Installed features: [cdi, kogito, resteasy, resteasy-jackson]
```
