var koa = require('koa');
var app = module.exports = new koa();
const server = require('http').createServer(app.callback());
const WebSocket = require('ws');
const wss = new WebSocket.Server({ server });
const Router = require('koa-router');
const cors = require('@koa/cors');
const bodyParser = require('koa-bodyparser');

app.use(bodyParser());

app.use(cors());

app.use(middleware);

function middleware(ctx, next) {
    const start = new Date();
    return next().then(() => {
        const ms = new Date() - start;
        console.log(`${start.toLocaleTimeString()} ${ctx.request.method} ${ctx.request.url} ${ctx.response.status} - ${ms}ms`);
    });
}

const getRandomInt = (min, max) => {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min)) + min;
};

const statuses = ['pending', 'preparing', 'delivering', 'canceled'];
const types = ['normal', 'priority', 'urgent'];
const orders = [];

for (let i = 0; i < 10; i++) {
    orders.push({
        id: i + 1,
        details: "Order " + getRandomInt(0, 10),
        status: statuses[getRandomInt(0, statuses.length)],
        user: getRandomInt(0, 5),
        age: getRandomInt(10, 20),
        type: types[getRandomInt(0, types.length)]
    });
}

const router = new Router();

router.get('/orders/:userid', ctx => {
    // console.log("ctx: " + JSON.stringify(ctx));
    const headers = ctx.params;
    const userid = headers.userid;
    if (typeof userid !== 'undefined') {
        // console.log("type: " + JSON.stringify(type));
        ctx.response.body = orders.filter(order => order.user == userid)
            // console.log("type: " + JSON.stringify(type) + "body: " + JSON.stringify(ctx.response.body));
        ctx.response.status = 200;
    } else {
        console.log("Missing or invalid: userid!");
        ctx.response.body = { text: 'Missing or invalid: userid!' };
        ctx.response.status = 404;
    }
});

router.get('/pending', ctx => {
    ctx.response.body = orders.filter(order => order.status === 'pending');
    ctx.response.status = 200;
});

router.post('/status', ctx => {
    // console.log("ctx: " + JSON.stringify(ctx));
    const headers = ctx.request.body;
    // console.log("body: " + JSON.stringify(headers));
    const id = headers.id;
    const status = headers.status;
    if (typeof id !== 'undefined' && typeof status !== 'undefined') {
        const index = orders.findIndex(order => order.id == id);
        if (index === -1) {
            console.log("Order not available!");
            ctx.response.body = { text: 'Order not available!' };
            ctx.response.status = 404;
        } else {
            let order = orders[index];
            order.status = status;
            // console.log("status changed: " + JSON.stringify(order));
            ctx.response.body = order;
            ctx.response.status = 200;
        }
    } else {
        console.log("Missing or invalid: id!");
        ctx.response.body = { text: 'Missing or invalid: id!' };
        ctx.response.status = 404;
    }
});

router.get('/all', ctx => {
    ctx.response.body = orders;
    ctx.response.status = 200;
});


const broadcast = (data) =>
    wss.clients.forEach((client) => {
        if (client.readyState === WebSocket.OPEN) {
            client.send(JSON.stringify(data));
        }
    });

router.post('/order', ctx => {
    // console.log("ctx: " + JSON.stringify(ctx));
    const headers = ctx.request.body;
    // console.log("body: " + JSON.stringify(headers));
    const details = headers.details;
    const status = headers.status;
    const user = headers.user;
    const age = headers.age;
    const type = headers.type;
    if (typeof details !== 'undefined' && typeof status !== 'undefined' &&
        typeof user !== 'undefined' && age !== 'undefined' && type !== 'undefined') {
        const index = orders.findIndex(order => order.details == details && order.user == user);
        if (index !== -1) {
            console.log("Order already exists!");
            ctx.response.body = { text: 'Order already exists!' };
            ctx.response.status = 404;
        } else {
            let maxId = Math.max.apply(Math, orders.map(function(order) {
                return order.id;
            })) + 1;
            let order = {
                id: maxId,
                details,
                status,
                user,
                age,
                type
            };
            // console.log("created: " + JSON.stringify(order));
            orders.push(order);
            broadcast(order);
            ctx.response.body = order;
            ctx.response.status = 200;
        }
    } else {
        console.log("Missing or invalid fields!");
        ctx.response.body = { text: 'Missing or invalid fields!' };
        ctx.response.status = 404;
    }
});


app.use(router.routes());
app.use(router.allowedMethods());

server.listen(2302);