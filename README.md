# Fast and Memory-Efficient Tucker decomposition for Answering Diverse Time Range Queries
This is a code for "Fast and Memory-Efficient Tucker decomposition for Answering Diverse Time Range Queries", submitted to KDD 2021.

## Code Information
All codes are written by MATLAB 2019b.
This repository contains the code for Zoom-Tucker (Time Range qUery cuStomized Tucker decomposition), a fast and memory-efficient Tucker decomposition method for revealing hidden factors of temporal dense tensor data in an arbitrary time range. Given a temporal dense tensor and a time range query, Zoom-Tucker finds the Tucker result of a sub-tensor obtained in the range. The Tucker result includes orthogonal factor matrices and a core tensor.
Our code requires Tensor Toolbox version 3.0 (available at https://gitlab.com/tensors/tensor_toolbox).

* The code of Zoom-Tucker is in `src` directory.
    * `preprocessing.m`: the code related to preprocessing a given temporal tensor block by block along the time dimension.
    * `partial.m`: the code related to adjusting the first block tensor and the last block tensor in the range.
    * `stitch.m`: the code related to computing the Tucker result of the given time range.
    * `update_nontemporal`: the code related to updating a factor matrix of a non-temporal mode.
    * `update_time`: the code related to updating the factor matrix of the temporal mode.
    * `update_core`: the code related to updating the core tensor.
* The libraries used for Zoom-Tucker are in `library` directory.
* The demo code of Zoom-Tucker is in `demo` directory.

## How to run for sample data
For a simple test, we generate a random tensor.
We provide demo scripts for our method, Zoom-Tucker.
First, you run the MATLAB program, and then you should add paths into MATLAB environment. Please type the following command in MATLAB:
    `addPaths`

Then, type the following command to run the preprocessing phase for a given data:
    `run run_demo_zoom_sample_preprocessing`

After finishing the preprocessing phase, type the following command to run the query phase for a given time range query:
 
   `run run_demo_zoom_sample_query`    

## How to run for real-world data
We used 6 real-world tensor datasets in the experiment.
We provide demo scripts for Stock dataset.
First, you download Stock dataset from [link](https://drive.google.com/file/d/1iMn0EpsCpE4FooINg1u4Z9I8OAktCW6h/view?usp=sharing), and extract the tgz file, and move the extracted folder to Zoom-Tucker directory (home directory of this repository).
Next, you run the MATLAB program, and then you should add paths into MATLAB environment. Please type the following command in MATLAB:
    `addPaths`


Then, type the following command to run the preprocessing phase for a given data:
    `run run_demo_zoom_realworld_preprocessing`

After finishing the preprocessing phase, type the following command to run the query phase for a given time range query:
    `run run_demo_zoom_realworld_query`       

You can run Zoom-Tucker on other datasets if you download them from links, and do data preprocessing like Stock dataset.

## Dataset
We used 6 real-world tensor datasets in the experiment.
The following table describes datasets used in our experiment, and you can download the datasets at the following links:


|  Dataset  | Dimensionality | Summary | Download |
|:---------:|:--------------:|:-------:|:--------:|
|   Boats   | (320,240,7000) |  Video  | [link](http://jacarini.dinf.usherbrooke.ca/dataset2012/)|
|   Video   |(1080,1980,2400)|  Video  | [link](https://github.com/OsmanMalik/tucker-tensorsketch)|
|   Stock   | (3028,54,3050) |  Time series  | [link](https://drive.google.com/file/d/1iMn0EpsCpE4FooINg1u4Z9I8OAktCW6h/view?usp=sharing)|
|  Traffic  | (1084,96,2000) |  Traffic Volume  | [link](https://github.com/florinsch/BigTrafficData)|
|    FMA    | (7994,1025,700)|  Music  | [link](https://github.com/mdeff/fma)|
|  Absorb   |(192,288,30,1200)|  Climate  | [link](https://www.earthsystemgrid.org/)|