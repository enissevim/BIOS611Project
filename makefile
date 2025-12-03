.PHONY: clean all
all: report.html

figures:
	mkdir -p figures

football_combined_cleaned.csv: data_import.R \
	2000-01.csv 2001-02.csv 2002-03.csv 2003-04.csv 2004-05.csv \
	2005-06.csv 2006-07.csv 2007-08.csv 2008-09.csv 2009-10.csv \
	2010-11.csv 2011-12.csv 2012-13.csv 2013-14.csv 2014-15.csv \
	2015-16.csv 2016-17.csv 2017-18.csv 2018-19.csv 2019-20.csv \
	2020-2021.csv london_weather.csv
	Rscript data_import.R

figures/pca_plot.png figures/pca_by_result.png: pca_analysis.R football_combined_cleaned.csv | figures
	Rscript pca_analysis.R

figures/goals_by_rain_normalized.png \
figures/goals_by_rain_intensity_normalized.png \
goals_by_precipitation_bins.csv: goals_weather_analysis.R football_combined_cleaned.csv | figures
	Rscript goals_weather_analysis.R

figures/tsne_results.png figures/tsne_weather.png tsne_results.csv: tsne_analysis.R football_combined_cleaned.csv | figures
	Rscript tsne_analysis.R

report.html: report.Rmd \
	figures/pca_plot.png \
	figures/pca_by_result.png \
	figures/goals_by_rain_normalized.png \
	figures/tsne_results.png \
	figures/tsne_weather.png \
	goals_by_precipitation_bins.csv \
	tsne_results.csv
	R -e "rmarkdown::render('report.Rmd')"

clean:
	rm -rf figures
	rm -f report.html
	rm -f football_combined_cleaned.csv
	rm -f goals_by_precipitation_bins.csv
	rm -f tsne_results.csv