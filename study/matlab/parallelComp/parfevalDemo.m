p = gcp();
f = parfeval(p, @magic, 1, 10);
value = fetchOutputs(f);
