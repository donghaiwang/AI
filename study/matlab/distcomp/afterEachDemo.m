q = parallel.pool.DataQueue;
afterEach(q, @disp);

parfor i = 1
    send(q, 2);
end
send(q, 3);

%%
D = parallel.pool.DataQueue;
listener = D.afterEach(@disp);

D.send(1);

delete(listener);
D.send(1);