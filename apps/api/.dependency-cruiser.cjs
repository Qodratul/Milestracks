module.exports = {
  forbidden: [
    {
      name: "domain-is-pure",
      severity: "error",
      from: { path: "^src/domain(?:/|$)" },
      to: { path: "^src/(?!domain(?:/|$)|types(?:/|$))" },
    },
    {
      name: "controllers-no-data-access",
      severity: "error",
      from: { path: "^src/controllers(?:/|$)" },
      to: { path: "^src/(?:repositories|providers)(?:/|$)" },
    },
    {
      name: "services-no-http",
      severity: "error",
      from: { path: "^src/services(?:/|$)" },
      to: { path: "^src/(?:controllers|routes|middleware)(?:/|$)" },
    },
    {
      name: "workers-call-services",
      severity: "error",
      from: { path: "^src/workers(?:/|$)" },
      to: { path: "^src/(?:repositories|providers|domain)(?:/|$)" },
    },
    {
      name: "providers-are-leaves",
      severity: "error",
      from: { path: "^src/providers(?:/|$)" },
      to: { path: "^src/(?:services|controllers|repositories|domain)(?:/|$)" },
    },
    {
      name: "repositories-no-business-or-provider-imports",
      severity: "error",
      from: { path: "^src/repositories(?:/|$)" },
      to: { path: "^src/(?:services|domain|providers)(?:/|$)" },
    },
    {
      name: "routes-do-not-call-services",
      severity: "error",
      from: { path: "^src/routes(?:/|$)" },
      to: { path: "^src/(?:services|repositories|providers)(?:/|$)" },
    },
    {
      name: "no-prisma-in-http-or-domain",
      severity: "error",
      from: { path: "^src/(?:routes|controllers|middleware|domain)(?:/|$)" },
      to: { path: "^@prisma/client$" },
    },
  ],
  options: { doNotFollow: { path: "node_modules" }, tsPreCompilationDeps: true },
};
