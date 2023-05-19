api-setup:
	cd text-review-api; bundle
	cd text-review-api; rails db:create db:migrate
api-run: 
	cd text-review-api; rails s
app-setup:
	cd text-review-app; yarn
app-run:
	cd text-review-app; yarn dev