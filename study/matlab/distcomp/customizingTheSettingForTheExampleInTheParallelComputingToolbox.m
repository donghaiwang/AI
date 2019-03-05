parallel.defaultClusterProfile();

%%
orgconf = paralleldemoconfig();
disp(orgconf);

paralleldemoconfig('NumTasks', 3);

%%
paralleldemoconfig('Difficulty', 0.5);
paralleldemo_blackjack_seq;