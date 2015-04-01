
exports.messageDef =
  'hello': [['realm', 'uri'], ['details', 'dict']]
  'welcome': [['session.id', 'id'], ['details', 'dict']]
  'abort': [['details', 'dict'], ['reason', 'uri']]
  'challenge': []
  'authenticate': []
  'goodbye': [['details', 'dict'], ['reason', 'uri']]
  'heartbeat': []
  'error': [['request.type', 'int'], ['request.id', 'id'],
    ['details', 'dict'], ['error', 'uri'], ['args', 'list', {optional: true}],
    ['kwargs', 'dict', {optional: true}]]
  'publish': [['request.id', 'id'], ['options', 'dict'], ['topic', 'uri'],
    ['args', 'list', {optional: true}], ['kwargs', 'dict', {optional: true}]]
  'published': [['publish.request.id', 'id'], ['publication.id', 'id']]
  'subscribe': [['request.id', 'id'], ['options', 'dict'], ['topic', 'uri']]
  'subscribed': [['subscribe.request.id', 'id'], ['subscription.id', 'id']]
  'unsubscribe': [['request.id', 'id'], ['subscribed.subscription.id', 'id']]
  'unsubscribed': [['unsubscribe.request.id', 'id']]
  'event': [['subscribed.subscription.id', 'id'],
    ['published.publication.id', 'id'], ['details', 'dict'],
    ['publish.args', 'list', {optional: true}],
    ['publish.kwargs', 'dict', {optional: true}]]
  'call': [['request.id', 'id'], ['options', 'dict'], ['procedure', 'uri'],
    ['args', 'list', {optional: true}], ['kwargs', 'dict', {optional: true}]]
  'cancel': []
  'result': [['call.request.id', 'id'], ['options', 'dict'],
    ['yield.args', 'list', {optional: true}],
    ['yield.kwargs', 'dict', {optional: true}]]
  'register': [['request.id', 'id'], ['options', 'dict'], ['procedure', 'uri']]
  'registered': [['register.request.id', 'id'], ['registration.id', 'id']]
  'unregister': [['request.id', 'id'], ['registered.registration.id', 'id']]
  'unregistered': [['unregister.request.id', 'id']]
  'invocation': [['request.id', 'id'], ['registered.registration.id', 'id'],
    ['details', 'dict'], ['call.args', 'list', {optional: true}],
    ['call.kwargs', 'dict', {optional: true}]]
  'interrupt': []
  'yield': [['invocation.request.id', 'id'], ['options', 'dict'],
    ['args', 'list', {optional: true}], ['kwargs', 'dict', {optional: true}]]

exports.messageTypeMap =
  1: 'hello'
  2: 'welcome'
  3: 'abort'
  4: 'challenge'
  5: 'authenticate'
  6: 'goodbye'
  8: 'error'
  16:	'publish'
  17:	'published'
  32:	'subscribe'
  33:	'subscribed'
  34:	'unsubscribe'
  35:	'unsubscribed'
  36:	'event'
  48:	'call'
  49:	'cancel'
  50:	'result'
  64:	'register'
  65:	'registered'
  66:	'unregister'
  67:	'unregistered'
  68:	'invocation'
  69:	'interrupt'
  70:	'yield'
