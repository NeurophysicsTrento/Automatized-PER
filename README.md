# Automatized-PER
Project title: Mechanical and electronic designs of an automatized Proboscis Extension Response assay for honey bees.

Project description: The proboscis extension response (PER) has been widely used for decades to evaluate honeybees’ (Apis mellifera) learning and memory abilities. This classical conditioning paradigm is traditionally administered manually, and produces a binary score for each subject depending on the presence or absence of the proboscis extension in response to a stimulus - typically an odor which has been associated with a sucrose reward - to classify whether or not the bee has learned the association. Here we present a fully automated PER system which delivers stimuli in a more controlled manner, and thus standardizes the protocol within and between labs; further, the AI-facilitated behavioral scoring reduces human error and allows us to extract a richer meaning from the outcome. The automated frame-by-frame assessment goes beyond the binary classification of “learned” or “not learned”, expanding the possibilities for many other measures. Using this method, we investigate the real-time decision-making processes of honeybees faced with difficult learning tasks. When posed with a quantitative (rather than qualitative, as in the case of different odors) PER association, honeybees show a pattern of rapid generalization to both the rewarded and non-rewarded stimuli, followed by a slowly acquired discrimination between the two. Our work lays the foundation for deeper exploration of the honeybee cognitive processes when posed with complex learning challenges.

Table of Contents:

Experiment 1 (olfactory).mat: Experimental data (after being analyzed by the neural network) for the first experiment with odors.

Experiment 2 (low flux rewarded).mat: Experimental data (after being analyzed by the neural network) for the second experiment with air flux, where the lower flux was rewarded.

Experiment 3 (high flux rewarded).mat: Experimental data (after being analyzed by the neural network) for the third experiment with air flux, where the higher flux was rewarded.

HP.m: the function for the high air flux (High Pressure) stimulus.

LP.m: the function for the low air flux (Low Pressure) stimulus.

OD1.m: the function for the first of two odors.

OD2.m: the function for the second of two odors.

PER_AIR_Flux.ino: the Arduino code to control two different air flux stimuli, one high and one low.

PER_Protocol.m: the master code to run a PER experiment.

PER_device.ino: the Arduino code to control all movements and stimuli except air flux.

PER_predict.m: the function which loads a raw experimental data set and analyzes it using the neural network.

PER_stat.m: the function which uses the output of the neural network to determine a binary scores.

Analyse_PER.m: the master code to run analyses on experimental data which has already been processed by the neural network.

Eval_licking.m: the function which visualizes real-time progress as the neural network analyzes a video.

Find_head_center.m: the function used during the experimental setup to optimize the camera view.

Label_frames.m: the function which allows the user to assign values to video frames during manual scoring.

movieScroll.m: the function to manually navigate video during scoring.

movie_Labeler.m: the function which loads a video for the user to label frames.

next_bee.m: the function for advancing the revolver to the next subject.

stim_prot.m: the function to control the sequence and timing of stimuli.

tismaq.m: the function for creating a video input object.

All .mat files were written in and run in MATLAB R2021b. 
Not included: the trained neural network (Matlab variable "net") and the video recordings (Matlab variable "data").
A detailed description/application can be found at: [publication link]
