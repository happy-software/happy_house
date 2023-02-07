# Happy House

Happy House is your personal assistant that helps 
manage your home.


### Getting Started - Development

Once the repo is cloned:

```bash
# To start the application
docker-compose up
```

At first, you'll need to create a database and seed it. You can use
docker-compose to accomplish this.

```bash
docker-compose run --rm web ./bin/setup
```

### Debugging with pry

To be able to hit breakpoints, you can run:
```bash
docker-compose up db
docker-compose run --service-ports web # in another terminal
```

See [this gist](https://gist.github.com/briankung/ebfb567d149209d2d308576a6a34e5d8#gistcomment-3186227) for more details.

### Testing

Create a file called `.env.test.local`, and add the following environment
variables:

```bash
DB_HOST="postgres"
DB_USERNAME="postgres"
```

Use the following command to run tests:

```bash
# To run every test
./test

# To run specific tests
./test <path_to_test(s)>
```

### Production

- `NODE_OPTIONS=--openssl-legacy-provider` 
  - This env var was added in Jan 2023 when attempting to upgrade the Heroku stack from 18 to 22.
  - We were getting an error that said the compliation was failing due to webpack not being found.
    - I followed the recommendation in [this thread](https://discuss.rubyonrails.org/t/deploying-to-heroku-command-webpack-not-found/76409) to include the nodejs buildpack but that produced another error.
  - We were getting an exception that looks like this:
  - ```
       Compiling...
       Compilation failed:
       node:internal/crypto/hash:71
         this[kHandle] = new _Hash(algorithm, xofLen);
                         ^
       
       Error: error:0308010C:digital envelope routines::unsupported
           at new Hash (node:internal/crypto/hash:71:19)
           at Object.createHash (node:crypto:133:10)
           at module.exports (/tmp/build_bf6d9384/node_modules/webpack/lib/util/createHash.js:135:53)
           at NormalModule._initBuildHash (/tmp/build_bf6d9384/node_modules/webpack/lib/NormalModule.js:417:16)
           at handleParseError (/tmp/build_bf6d9384/node_modules/webpack/lib/NormalModule.js:471:10)
           at /tmp/build_bf6d9384/node_modules/webpack/lib/NormalModule.js:503:5
           at /tmp/build_bf6d9384/node_modules/webpack/lib/NormalModule.js:358:12
           at /tmp/build_bf6d9384/node_modules/loader-runner/lib/LoaderRunner.js:373:3
           at iterateNormalLoaders (/tmp/build_bf6d9384/node_modules/loader-runner/lib/LoaderRunner.js:214:10)
           at iterateNormalLoaders (/tmp/build_bf6d9384/node_modules/loader-runner/lib/LoaderRunner.js:221:10)
           at /tmp/build_bf6d9384/node_modules/loader-runner/lib/LoaderRunner.js:236:3
           at context.callback (/tmp/build_bf6d9384/node_modules/loader-runner/lib/LoaderRunner.js:111:13)
           at /tmp/build_bf6d9384/node_modules/babel-loader/lib/index.js:44:71 {
         opensslErrorStack: [ 'error:03000086:digital envelope routines::initialization error' ],
         library: 'digital envelope routines',
         reason: 'unsupported',
         code: 'ERR_OSSL_EVP_UNSUPPORTED'
       }
       
       Node.js v18.13.0
       
    !
    !     Precompiling assets failed.
    !
    !     Push rejected, failed to compile Ruby app.
    !     Push failed
    ```
  - So if we can solve this in the future, feel free to remove this env var.
