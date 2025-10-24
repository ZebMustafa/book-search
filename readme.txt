Install latest maven

Going to create maven project by following command:

mvn archetype:generate -DgroupId=com.h2 -DartifactId=book-search -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false

It setup basic structure with java application.

mvn clean -> The removal of all the artifacts that if has been created.
mvn install -> compile the code and create the new artifacts.

To run the maven main class:
mvn exec:java -Dexec.mainClass="com.h2.App"