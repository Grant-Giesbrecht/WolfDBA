/*
This program converts a KV1 file formatted for HBA databases to that used for MATLAB
banking Databases.
*/

//CXCOMPILE clang++ -o hba_to_mb hba_to_mb.cpp -std=c++11 -lIega

#include <iostream>
#include <stdio.h>
#include <string>
#include <vector>
#include <fstream>
#include <sstream>
#include <IEGA/string_manip.hpp>

using namespace std;

int main(){

    vector<string> file_out;
    string filename_output = "USAA_Visa2018fmt.kv1";

    int entry_count = 0;
    double balance = 0;
    double basis = 0;

    ifstream infile("USAA_Visa2018.KV1");
    string line;
    while (std::getline(infile, line)){

        file_out.push_back(line);

        //Check to see if this is the catgory line, if so, add the IDgroup line after...
        size_t idx0 = line.find("[");
        size_t idx1 = line.find("cat");
        if (idx0 != string::npos && idx1 != string::npos && idx1 < idx0){
            file_out.push_back("m<s> t" + to_string(entry_count) + "idg [\"\"];");
        }

        //Check to see if this is the catgory line, if so, add the IDgroup line after...
        idx0 = line.find("[");
        idx1 = line.find("val");
        size_t idx2 = line.find(";");
        vector<string> words = parse(line, " ;");
        if (idx0 == string::npos && idx1 != string::npos && idx2 != string::npos && idx1 < idx2){
            balance += strtod(words[2]); //Update balance
            file_out.push_back("d t" + to_string(entry_count) + "bal " + dtos(balance, 2, 6) + ";");
            if (basis == 0){
                file_out.push_back("d t" + to_string(entry_count) + "bas 0;");
            }else{
                file_out.push_back("d t" + to_string(entry_count) + "bas " + dtos(basis, 2, 6) + ";");
            }

            entry_count++;
        }


    }

    for (int i = 0 ; i < file_out.size() ; i++){
        cout << file_out[i] << endl;
    }


    //Write new file
    ofstream myfile (filename_output);
    if (!myfile.is_open()){
        cout << "ERROR: Failed to open output file." << endl;
        return -1;
    }
    for (int i = 0 ; i < file_out.size() ; i++){
        myfile << file_out[i] << endl;
    }
    myfile.close();

    return 0;
}
