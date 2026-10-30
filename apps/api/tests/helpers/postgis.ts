import { GenericContainer, Wait } from "testcontainers";

export async function startPostgis(): Promise<{
  connectionString: string;
  stop: () => Promise<void>;
}> {
  const container = await new GenericContainer("postgis/postgis:16-3.4")
    .withEnvironment({
      POSTGRES_DB: "milestride_test",
      POSTGRES_USER: "milestride",
      POSTGRES_PASSWORD: "milestride",
    })
    .withExposedPorts(5432)
    .withWaitStrategy(
      Wait.forLogMessage("database system is ready to accept connections", 2),
    )
    .start();
  const connectionString =
    "postgresql://milestride:milestride@" +
    container.getHost() +
    ":" +
    container.getMappedPort(5432) +
    "/milestride_test";
  return {
    connectionString,
    stop: async () => {
      await container.stop();
    },
  };
}
