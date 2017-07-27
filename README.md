
# The ThredUP JWT Challenge!

## Build a CLI for generating JSON Web Tokens (JWT's)

The CLI should be able to take multiple key value pairs as input, and copy the generated JWT to your clipboard.

Required inputs are `user_id` and `email`. In addition, other key/value pairs may also be entered.

***An example session could look like this:***
```bash
$ jwt_me
Starting with JWT token generation.
Enter key 1
$ user_id
Enter user_id value
$ 12312
Enter key 2
$ email
Enter email value
$ something
Invalid email entered! Enter email value
$ syed@thredup.com
Any additional inputs? (yes/no)
$ no
The JWT has been copied to your clipboard!
```
