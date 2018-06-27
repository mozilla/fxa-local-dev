const check = require("check-node-version");

check(
    { node: ">= 8", npm: ">= 6" },
    (error, results) => {
        if (error) {
            console.error(error);
            return;
        }

        if (results.isSatisfied) {
            console.log("Node and nvm version ok");
            return;
        }

        console.error("Some package version(s) failed!");

        for (const packageName of Object.keys(results.versions)) {
            if (!results.versions[packageName].isSatisfied) {
                if(packageName === 'npm')
                  console.error(`Npm version must be > 5.8. Run the following command to upgrade npm "npm i -g npm@5"`);
                else if(packageName === 'node')
                  console.error(`Node version must be > 8`);
                else
                  console.error(`Missing ${packageName}.`);
                process.exit(1);
            }
        }
    }
);
