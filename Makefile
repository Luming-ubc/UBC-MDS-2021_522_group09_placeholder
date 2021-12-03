# Wine Quality Predictor Data Pipe
# Author: Paniz Fazlali
# Date: 2021-12-01
# 
# Usage:
# make all

all : docs/wine_quality_predictor_report/_build/html/bibliography.html docs/wine_quality_predictor_report/_build/html/genindex.html docs/wine_quality_predictor_report/_build/html/index.html docs/wine_quality_predictor_report/_build/html/report_introduction.html docs/wine_quality_predictor_report/_build/html/report_methods.html docs/wine_quality_predictor_report/_build/html/report_results.html docs/wine_quality_predictor_report/_build/html/report_single.html docs/wine_quality_predictor_report/_build/html/report_summary.html docs/wine_quality_predictor_report/_build/html/search.html

# downloading data
data/raw/winequality-red.csv : src/download_data.py
	python src/download_data.py --url="https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv" --out_file="data/raw/winequality-red.csv" --delimiter=";"

data/raw/winequality-white.csv : src/download_data.py
	python src/download_data.py --url="https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv" --out_file="data/raw/winequality-white.csv" --delimiter=";"  

# preprocessing data
data/processed/train_df.csv data/processed/test_df.csv : src/preprocess_data.py data/raw/winequality-red.csv data/raw/winequality-white.csv 
	python src/preprocess_data.py --input_path_white="data/raw/winequality-white.csv" --input_path_red="data/raw/winequality-red.csv" --output_dir="data/processed"  

# eda
results/figure_1_class_imbalance.png results/figure_2_red_and_white_quantities.png results/figure_3_distribution_of_features.png results/figure_4_correlation_plot.png results/table_1_combined_dataset.csv table_2_observations_count.csv table_3_summary.csv : src/eda.py data/processed/train_df.csv
	python src/eda.py --input_data="data/processed/train_df.csv" --output_dir="results"

# machine learning analysis
results/cross_val_results.csv results/feature_importances.csv results/random_forest_results.csv results/test_cm.png : src/machine_learning.py data/processed
	python src/machine_learning.py --input_path_train="data/processed/train_df.csv" --input_path_test="data/processed/test_df.csv" --output_dir="results"

# final report
docs/wine_quality_predictor_report/_build/html/bibliography.html docs/wine_quality_predictor_report/_build/html/genindex.html docs/wine_quality_predictor_report/_build/html/index.html docs/wine_quality_predictor_report/_build/html/report_introduction.html docs/wine_quality_predictor_report/_build/html/report_methods.html docs/wine_quality_predictor_report/_build/html/report_results.html docs/wine_quality_predictor_report/_build/html/report_single.html docs/wine_quality_predictor_report/_build/html/report_summary.html docs/wine_quality_predictor_report/_build/html/search.html : results/figure_1_class_imbalance.png results/figure_2_red_and_white_quantities.png results/figure_3_distribution_of_features.png results/table_1_combined_dataset.csv table_2_observations_count.csv table_3_summary.csv results/cross_val_results.csv results/feature_importances.csv results/random_forest_results.csv results/test_cm.png
	jupyter-book build docs/wine_quality_predictor_report

clean :
	rm -rf data/raw/winequality-red.csv data/raw/winequality-white.csv
	rm -rf data/processed/train_df.csv data/processed/test_df.csv
	rm -rf results/cross_val_results.csv results/feature_importances.csv results/figure_1_class_imbalance.png results/figure_2_red_and_white_quantities.png results/figure_3_distribution_of_features.png results/random_forest_results.csv results/table_1_combined_dataset.csv results/table_2_observations_count.csv results/table_3_summary.csv results/test_cm.png results/random_forest.rds
	rm -rf docs/wine_quality_predictor_report/_build/html/bibliography.html docs/wine_quality_predictor_report/_build/html/genindex.html docs/wine_quality_predictor_report/_build/html/index.html docs/wine_quality_predictor_report/_build/html/report_introduction.html docs/wine_quality_predictor_report/_build/html/report_methods.html docs/wine_quality_predictor_report/_build/html/report_results.html docs/wine_quality_predictor_report/_build/html/report_single.html docs/wine_quality_predictor_report/_build/html/report_summary.html docs/wine_quality_predictor_report/_build/html/search.html