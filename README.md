# **BIOS 611 Final Project**

This project analyzes the relationship between **weather conditions** and **Premier League match performance** for London-based clubs from 2000 through 2021.  
All analyses are fully reproducible using Docker and a Makefile, following the workflow taught in BIOS 611.

---

# **Project Structure**

The project follows the standard **reproducible pipeline**:

- **data_import.R**  
  Imports raw match CSV files and London weather data, filters for London home teams, merges sources, and produces:  
  `football_combined_cleaned.csv`

- **pca_analysis.R**  
  Performs principal component analysis and generates:  
  - `figures/pca_plot.png`  
  - `figures/pca_by_result.png`

- **goals_weather_analysis.R**  
  Creates violin plots and precipitation summary tables:  
  - `figures/goals_by_rain_normalized.png`  
  - `goals_by_precipitation_bins.csv`

- **tsne_analysis.R**  
  Runs t-SNE embedding and outputs:  
  - `figures/tsne_results.png`  
  - `figures/tsne_weather.png`  
  - `tsne_results.csv`

- **build_model.R** / **evaluate_model.R**  
  Trains and evaluates an XGBoost classifier:  
  - `build_model.rds`  
  - `xgboost_acc.txt`

- **partial_correlation.R**  
  Computes partial correlations between weather variables and match performance:  
  - `partial_correlation_results.csv`

- **report.Rmd**  
  Final write-up combining all results.

- **Makefile**  
  Controls all dependencies and ensures full reproducibility.

---

# **Reproducibility Requirements**

This project must run identically on any machine using Docker.  
You will need:

- Docker installed  
- RStudio interface from the container  
- All raw CSV match files in your working directory

---

# **Build the Docker Image**

```bash
docker build -t project .
```

This installs:

- tidyverse  
- caret  
- xgboost  
- rmarkdown  
- lubridate  
- factoextra  
- Rtsne  

---

# **Run the Container**

```bash
docker run -e PASSWORD=project \
  -v $(pwd):/home/rstudio/work \
  -p 8787:8787 project
```

Open RStudio in a browser:

```
http://localhost:8787
```

Login:

- **username:** rstudio  
- **password:** project  

---

# **Rebuild the Entire Project**

Inside the container terminal:

```bash
make report.html
```

This triggers:

1. Data import  
2. PCA, t-SNE, and XGBoost modeling  
3. Plot + table generation  
4. Final knitted report: **report.html**

---

# **Cleaning Outputs**

```bash
make clean
```

Removes all generated files.

---

# **Final Output Files**

After running `make report.html` or `make all`, you will see:

### **Report**
- `report.html`

### **Figures**
- `figures/pca_plot.png`
- `figures/pca_by_result.png`
- `figures/goals_by_rain_normalized.png`
- `figures/tsne_results.png`
- `figures/tsne_weather.png`

### **Tables**
- `goals_by_precipitation_bins.csv`
- `partial_correlation_results.csv`
- `tsne_results.csv`

### **Model Files**
- `build_model.rds`
- `xgboost_acc.txt`

---