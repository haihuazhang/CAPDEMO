'use strict';

const express = require('express');
const http = require('http');

const proxy = require('@sap/cds-odata-v2-adapter-proxy');

const xsenv = require('@sap/xsenv');

const host = '0.0.0.0';
const port = process.env.PORT || 4004;

(async () => {
  const app = express();

  // serve odata v2
  process.env.XS_APP_LOG_LEVEL = 'warning';
  app.use(
    proxy({
      path: 'v2',
      target: 'http://localhost:8001',
      services: {
        '/odata/v4/MSTService': 'MSTService',
        '/odata/v4/PCHService': 'PCHService',
        '/odata/v4/PCH02Service': 'PCH02Service',
        '/odata/v4/PCH08Service': 'PCH08Service',
      },
    }),
  );
  // start server
  const server = app.listen(port, host, () =>
    console.info(`app is listing at ${host}:${port}`),
  );
  server.on('error', (error) => console.error(error.stack));
})();
