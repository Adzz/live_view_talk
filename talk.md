### The (absolute) State of LiveView

Contents

  1. What is Live View
  2. A motivating example
  3. Changesets, Multis and Sagas
  4. All of the above; Business Logic Middleware
  5. The exact API
  6. Tracing, extensibility, (re)usability, testing
  7.

### What is Live View

The server sends HTML etc to the client, and establishes a websocket connection. That means
  1. HTML gets sent - Yay SEO, yay fast (and simple!) time to first meaningful paint
  2. Now we have fast two way communication with the server (no overhead of establishing a connection to the backend each time you want to do something).

That means we can manage client / front end state on the bloody backend! Without Javascript! In Elixir!

LiveView adds lots of extra niceties like diffing of data sent over the wire (each state update sends a minimal amount of data back and forth - we patch the DOM a la React), and we get really nice graceful degradation because it leverages process architecture.

Also testing is a breeze.

### Mr Motivator

So we have a vague mental model of what live view is. Let's look at an example.

We are Duffel so we are making travel painless. So naturally that includes Time Travel.

Our app is going to let us buy tickets for time travel / list previous journies. Whenever we make a change in our app, we need to ensure that we can't edit the past. So past tickets can't be changed, past seating arrangements can't be changed. Past passenger names, luggage allowances... cannot be changed.

That means we have business logic spanning contexts, spanning events / actions that we can take.


The problem we need to get to is a sharing of business logic across contexts. Authorisation is a good example but also time based issues a la HM. Also tracing.

Thinking of it like middleware can give us extra benefits too; we can process that middleware with different semantics. Like, fail fast, collect errors, with / rollback...

We'll come back and finalize the example when we know what we are doing with it.

### Changesets, Multis and Sagas.

They are great. But focused on changes to a schema, or across schemas. Sagas get a lot closer, but are more focused on distributed transactions. I'm not sure if authorisation really fits for example.

### All of the above - Business Logic Middleware

If we think of the events in our app as a request, as an actual data structure that gets manipulated then we get a lot of benefits.

Separate the FE state from the business logic. State in live view is not necessarily related to business logic. A trivial example is if we choose to use some live view state to show or hide some markup. It's certainly not business logic whether the thing shows or hides, so we want to be sure to drop that sort of information when we serve the request. But that might mean we need to know how to translate our business logic to and from the live view state - e.g. if it was successful then hide the modal... stuff like that.

so we want something that shows / hides based on state of the FE, but isn't biz logic. We want some actions with biz logic that spans them. And we want those examples to be simple.


Deadline. So what happens with deadlines? They change. And right now if they change, that's X changes (and tests!) to change. Instead we can change it in one place. Cool.

Declarative - I can see the exact steps that go into doing the thing.
<!-- This point is really about resolvers in Graphql. Resolvers are not the place for business logic. Neither is absinthe middlewares -->
<!-- Reuse. We have a button click on our UI for an action that there is also a cron job for. So our cron job we want to be able to re-use all of that biz logic. -->
Powerful - I can now make changes that affect lots of things -> like add tracing, change business rules (deadline is now 1 day... etc)
Manifest - what's happening is easy to understand - it's a reduce_while.



























