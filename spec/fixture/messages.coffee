exports.messages = [
  [1, "somerealm", "roles": {"publisher": {}, "subscriber": {}} ]
  [2, 9129137332, "roles": "broker": {} ]
  [3, {"message": "The realm does not exist."}, "wamp.error.no_such_realm"]
  [6, {"message": "The host is shutting down."}, "wamp.error.system_shutdown"]
  [32, 713845233, {}, "com.myapp.mytopic1"]
  [33, 713845233, 5512315355]
  [8, 32, 713845233, {}, "wamp.error.not_authorized"]
  [34, 85346237, 5512315355]
  [35, 85346237]
  [8, 34, 85346237, {}, "wamp.error.no_such_subscription"] #unsubscribe error

  [16, 239714735, {}, "com.myapp.mytopic1", ["Hello, world!"]]

  [17, 239714735, 4429313566]
  [8, 16, 239714735, {}, "wamp.error.not_authorized"]
  [36, 5512315355, 44293566, {}, [], {"color": "orange", "sizes": [23, 42, 7]}]

  [64, 25349185, {}, "com.myapp.myprocedure1"]
  [65, 25349185, 2103333224]

  [66, 788923562, 2103333224]
  [67, 788923562]

  [48, 7814135, {}, "com.myapp.echo", ["Hello, world!"]]
  [68, 6131533, 9823529, {}, ["johnny"], {"firstname": "John", "sname": "Doe"}]

  [70, 6131533, {}, [], {"userid": 123, "karma": 10}]
  [50, 7814135, {}, ["Hello, world!"]]
]
