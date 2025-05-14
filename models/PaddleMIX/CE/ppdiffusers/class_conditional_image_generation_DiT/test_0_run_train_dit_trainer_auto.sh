sed -i 's|per_device_train_batch_size=32|per_device_train_batch_size=16|' 0_run_train_dit_trainer_auto.sh
sed -i 's|max_steps=7000000|max_steps=10|' 0_run_train_dit_trainer_auto.sh
sed -i 's|save_steps=5000|save_steps=10|' 0_run_train_dit_trainer_auto.sh
sh 0_run_train_dit_trainer_auto.sh