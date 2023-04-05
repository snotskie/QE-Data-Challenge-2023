# Default behavior
serve: data/output/results.json .setup_complete
	chmod +x ./scripts/helpers/node_launch.sh
	chmod +x ./scripts/04-serve.js
	./scripts/04-serve.js

data/output/results.json: data/processed/data.csv scripts/03-analyze.jl .setup_complete
	chmod +x ./scripts/03-analyze.jl
	./scripts/03-analyze.jl

data/processed/data.csv: data/raw/data.csv scripts/02-process.py .setup_complete
	chmod +x ./scripts/02-process.py
	./scripts/02-process.py

data/raw/data.csv: scripts/01-gather.py .setup_complete
	chmod +x ./scripts/01-gather.py
	./scripts/01-gather.py
	touch data/raw/data.csv

.setup_complete: scripts/00-setup.sh
	chmod +x ./scripts/00-setup.sh
	./scripts/00-setup.sh

# Manual options for specific steps of the workflow
setup:
	chmod +x ./scripts/00-setup.sh
	./scripts/00-setup.sh

gather:
	chmod +x ./scripts/01-gather.py
	./scripts/01-gather.py
	touch data/raw/data.csv

process:
	chmod +x ./scripts/02-process.py
	./scripts/02-process.py

analyze:
	chmod +x ./scripts/03-analyze.jl
	./scripts/03-analyze.jl

# Additional options
clean:
	rm public/figs/*
