sed -i 's|epochs=1400|epochs=1|' 1_run_train_dit_notrainer.sh
sed -i 's|global_batch_size=256|global_batch_size=128|' 1_run_train_dit_notrainer.sh
sh 1_run_train_dit_notrainer.sh