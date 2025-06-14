val scala2Version = "2.12.17"

// val scala3Version = "3.6.4"

lazy val root = project
  .in(file("."))
  .settings(
    name := "scala2",
    version := "0.1.0",
    libraryDependencies += "org.scalameta" %% "munit" % "0.7.29" % Test,
    libraryDependencies += "org.apache.spark" %% "spark-core" % "3.5.1", // cross CrossVersion.for3Use2_12,
    libraryDependencies += "org.apache.spark" %% "spark-sql" % "3.5.1", // cross CrossVersion.for3Use2_12,

    // libraryDependencies += "org.apache.spark" %% "spark-core" % "3.5.1",
    // libraryDependencies += "org.apache.spark" %% "spark-sql"  % "3.5.1",
    // // To make the default compiler and REPL use Dotty
    scalaVersion := scala2Version,

    // To cross compile with Scala 3 and Scala 2
    crossScalaVersions := Seq(scala2Version)
    // assembly / mainClass := Some("your.package.MainClass")

    // assembly / assemblyMergeStrategy := {
    //   case PathList("META-INF", _ @ _*) => MergeStrategy.discard
    //   case _ => MergeStrategy.first
    // }

  )
