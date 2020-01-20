const koa = require('koa');
const app = new koa();
const server = require('http').createServer(app.callback());
const Router = require('koa-router');
const cors = require('koa-cors');
const bodyParser = require('koa-bodyparser');
const convert = require('koa-convert');

app.use(bodyParser());
app.use(convert(cors()));
app.use(async(ctx, next) => {
    const start = new Date();
    await next();
    const ms = new Date() - start;
    console.log(`${ctx.method} ${ctx.url} ${ctx.response.status} - ${ms}ms`);
});

const getRandomInt = (min, max) => {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min)) + min;
};

const bikeNames = ['Thunder', 'Rainbow', 'Tiger', 'Big', 'Small'];
const bikeTypes = ['Child', 'Women', 'Men'];
const bikeSize = ['Small', 'Medium', 'Large'];
const ownerNames = ['Lincoln Burrows', 'Michael Scofield', 'Alexander Mahone', 'Sara Tancredi', 'John Abruzzi', 'Fernando Sucre', 'Brad Bellick', 'Paul Kellerman'];
const statuses = ['available', 'taken', 'broken'];
const bikes = [];
for (let i = 0; i < 10; i++) {
    bikes.push({
        id: i + 1,
        name: bikeNames[getRandomInt(0, bikeNames.length)],
        type: bikeTypes[getRandomInt(0, bikeTypes.length)],
        size: bikeSize[getRandomInt(0, bikeSize.length)],
        owner: ownerNames[getRandomInt(0, ownerNames.length)],
        status: statuses[getRandomInt(0, statuses.length)]
    });
}

const router = new Router();
router.get('/bikes', ctx => {
    ctx.response.body = bikes.filter(bike => bike.status === statuses[0]);
    ctx.response.status = 200;
});

router.get('/all', ctx => {
    ctx.response.body = bikes;
    ctx.response.status = 200;
});

router.post('/loan', ctx => {
    // console.log("ctx: " + JSON.stringify(ctx));
    const headers = ctx.request.body;
    // console.log("body: " + JSON.stringify(headers));
    const id = headers.id;
    if (typeof id !== 'undefined') {
        const index = bikes.findIndex(bike => bike.id == id);
        if (index === -1) {
            console.log("Bike not available!");
            ctx.response.body = { text: 'Bike not available!' };
            ctx.response.status = 404;
        } else {
            let bike = bikes[index];
            bike.status = statuses[1];
            ctx.response.body = bike;
            ctx.response.status = 200;
        }
    } else {
        console.log("Missing or invalid: id!");
        ctx.response.body = { text: 'Missing or invalid: id!' };
        ctx.response.status = 404;
    }
});

router.post('/return', ctx => {
    // console.log("ctx: " + JSON.stringify(ctx));
    const headers = ctx.request.body;
    // console.log("body: " + JSON.stringify(headers));
    const id = headers.id;
    if (typeof id !== 'undefined') {
        const index = bikes.findIndex(bike => bike.id == id);
        if (index === -1) {
            console.log("Bike not available!");
            ctx.response.body = { text: 'Bike not available!' };
            ctx.response.status = 404;
        } else {
            let bike = bikes[index];
            bike.status = statuses[0];
            ctx.response.body = bike;
            ctx.response.status = 200;
        }
    } else {
        console.log("Missing or invalid: id!");
        ctx.response.body = { text: 'Missing or invalid: id!' };
        ctx.response.status = 404;
    }
});


router.post('/bike', ctx => {
    // console.log("ctx: " + JSON.stringify(ctx));
    const headers = ctx.request.body;
    // console.log("body: " + JSON.stringify(headers));
    const name = headers.name;
    const type = headers.type;
    const size = headers.size;
    const owner = headers.owner;
    if (typeof name !== 'undefined' && typeof type !== 'undefined' && typeof size !== 'undefined' &&
        typeof owner !== 'undefined') {
        const index = bikes.findIndex(bike => bike.name == name);
        if (index !== -1) {
            console.log("Bike already exists!");
            ctx.response.body = { text: 'Bike already exists!' };
            ctx.response.status = 404;
        } else {
            let maxId = Math.max.apply(Math, bikes.map(function(bike) {
                return bike.id;
            })) + 1;
            let bike = {
                id: maxId,
                name,
                type,
                size,
                owner,
                status: statuses[0]
            };
            bikes.push(bike);
            ctx.response.body = bike;
            ctx.response.status = 200;
        }
    } else {
        console.log("Missing or invalid: name, type, size or owner!");
        ctx.response.body = { text: 'Missing or invalid: name, type, size or owner!' };
        ctx.response.status = 404;
    }
});

router.del('/bike/:id', ctx => {
    // console.log("ctx: " + JSON.stringify(ctx));
    const headers = ctx.params;
    // console.log("body: " + JSON.stringify(headers));
    const id = headers.id;
    if (typeof id !== 'undefined') {
        const index = bikes.findIndex(bike => bike.id == id);
        if (index === -1) {
            console.log("No bike with id: " + id);
            ctx.response.body = { text: 'Invalid bike id' };
            ctx.response.status = 404;
        } else {
            let bike = bikes[index];
            bikes.splice(index, 1);
            ctx.response.body = bike;
            ctx.response.status = 200;
        }
    } else {
        ctx.response.body = { text: 'Id missing or invalid' };
        ctx.response.status = 404;
    }
});

app.use(router.routes());
app.use(router.allowedMethods());

server.listen(2028);