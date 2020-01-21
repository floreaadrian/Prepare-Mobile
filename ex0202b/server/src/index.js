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

const pacientNames = ['John', 'Johnny', 'Will', 'Ed'];
const recordTypes = ['admit', 'transfer', 'discharge', 'registration', 'update'];
const statusTypes = ['new', 'old'];
const recordDetails = ['visit', 'insurance', 'foo', 'bar'];
let records = [];
const patients = [];

for (let i = 0; i < 5; i++) {
    patients.push({
        id: i + 1,
        name: pacientNames[getRandomInt(0, pacientNames.length - 1)] + " " + (i + 1)
    });
}

for (let i = 0; i < 10; i++) {
    let patient = patients[getRandomInt(0, patients.length - 1)];
    records.push({
        id: i + 1,
        name: patient.name,
        patientId: patient.id,
        type: recordTypes[getRandomInt(0, recordTypes.length - 1)],
        details: recordDetails[getRandomInt(0, recordDetails.length - 1)],
        status: statusTypes[getRandomInt(0, statusTypes.length - 1)],
        date: 1517507405 + i
    });
}

const router = new Router();
router.get('/patients', ctx => {
    ctx.response.body = patients;
    ctx.response.status = 200;
});

router.get('/records/:id', ctx => {
    const headers = ctx.params;
    console.log("body: " + JSON.stringify(headers));
    const id = headers.id;
    if (typeof id !== 'undefined') {
        ctx.response.body = records.filter(record => record.patientId == id);
        ctx.response.status = 200;
    } else {
        ctx.response.body = {text: 'Missing id or invalid'};
        ctx.response.status = 404;
    }
});


router.get('/details/:id', ctx => {
    const headers = ctx.params;
    console.log("body: " + JSON.stringify(headers));
    const id = headers.id;
    if (typeof id !== 'undefined') {
        const index = records.findIndex(record => record.id == id);
        if (index === -1) {
            console.log("Record not available");
            ctx.response.body = {text: 'Record not available!'};
            ctx.response.status = 404;
        } else {
            ctx.response.body = records[index];
            ctx.response.status = 200;
        }
    } else {
        ctx.response.body = {text: 'Missing id or invalid'};
        ctx.response.status = 404;
    }
});


router.get('/all', ctx => {
    ctx.response.body = patients;
    ctx.response.status = 200;
});

router.post('/add', ctx => {
    const headers = ctx.request.body;
    console.log("body: " + JSON.stringify(headers));
    const patientId = headers.patientId;
    const recordType = headers.type;
    const details = headers.details;
    const status = headers.status;
    if (typeof patientId !== 'undefined' && typeof recordType !== 'undefined' &&
        typeof details !== 'undefined' && typeof status !== 'undefined') {
        const index = records.findIndex(record => record.patientId == patientId && record.type === recordType);
        const indexPatient = patients.findIndex(patient => patient.id == patientId);

        if (indexPatient === -1) {
            console.log("Invalid patient id!");
            ctx.response.body = {text: 'Invalid patient id!'};
            ctx.response.status = 404;
        } else {
            let patient = patients[indexPatient];
            if (index === -1) {
                let maxId = Math.max.apply(Math, records.map(function (record) {
                        return record.id;
                    })) + 1;
                let record = {
                    id: maxId,
                    name: patient.name,
                    patientId,
                    type: recordType,
                    details,
                    status,
                    date: 1517507405
                };
                records.push(record);
                ctx.response.body = record;
                ctx.response.status = 200;
            } else {
                console.log("Record already exists!");
                ctx.response.body = {text: 'Record already exists!'};
                ctx.response.status = 404;
            }
        }
    } else {
        console.log("Invalid request one or more fields are missing!");
        ctx.response.body = {text: 'Invalid request one or more fields are missing!'};
        ctx.response.status = 404;
    }
});


router.del('/patient/:id', ctx => {
    const headers = ctx.params;
    console.log("body: " + JSON.stringify(headers));
    const id = headers.id;
    if (typeof id !== 'undefined') {
        const index = patients.findIndex(patient => patient.id == id);
        if (index === -1) {
            console.log("No such patient!");
            ctx.response.body = {text: 'No such patient!'};
            ctx.response.status = 404;
        } else {
            let patient = patients[index];
            patients.splice(index, 1);
            records = records.filter(record => record.patientId != id);

            ctx.response.body = patient;
            ctx.response.status = 200;
        }
    } else {
        ctx.response.body = {text: 'Missing id or invalid'};
        ctx.response.status = 404;
    }
});

router.del('/nuke', ctx => {
    console.log("zap all the patients.");
    patients.splice(0, patients.length);
    ctx.response.body = {text: 'Zap done.'};
    ctx.response.status = 200;
});

app.use(router.routes());
app.use(router.allowedMethods());

server.listen(4022);