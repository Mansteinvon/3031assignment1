*** Settings ***
Library           Collections
Library           RequestsLibrary
Test Timeout      30 seconds

Suite Setup    Create Session    localhost    http://localhost:8080

*** Test Cases ***
addActorPass
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${params}=    Create Dictionary    name=Leo DiCaprio    actorId=LD1
    ${resp}=    PUT On Session    localhost    /api/v1/addActor    json=${params}    headers=${headers}    expected_status=200

addActorFail
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${params}=    Create Dictionary    name=Leo DiCaprio
    ${resp}=    PUT On Session    localhost    /api/v1/addActor    json=${params}    headers=${headers}    expected_status=400

addMoviePass
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${params}=    Create Dictionary    name=Oppenheimer    movieId=OP1
    ${resp}=    PUT On Session    localhost    /api/v1/addMovie    json=${params}    headers=${headers}    expected_status=200

addMovieFail
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${params}=    Create Dictionary    name=Oppenheimer    movieIdentification=OP1
    ${resp}=    PUT On Session    localhost    /api/v1/addMovie    json=${params}    headers=${headers}    expected_status=400

addRelationshipPass
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${actor_data}=    Create Dictionary    name=Leo DiCaprio    actorId=LDC1
    ${movie_data}=    Create Dictionary    name=The Revenant    movieId=TRVN1


    ${actor_resp}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_data}    headers=${headers}    expected_status=200
    ${movie_resp}=    PUT On Session    localhost    /api/v1/addMovie    json=${movie_data}    headers=${headers}    expected_status=200

    ${params}=    Create Dictionary    actorId=LDC1    movieId=TRVN1
    
    ${resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${params}    headers=${headers}    expected_status=200

addRelationshipFail
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${actor_data}=    Create Dictionary    name=Leo DiCaprio    actorId=LDC1
    ${movie_data}=    Create Dictionary    name=The Revenant    movieId=TRVN1


    ${actor_resp}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_data}    headers=${headers}    expected_status=200
    ${movie_resp}=    PUT On Session    localhost    /api/v1/addMovie    json=${movie_data}    headers=${headers}    expected_status=200

    ${params}=    Create Dictionary    actorId=LDC1    movieId=TRVN2
    
    ${resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${params}    headers=${headers}    expected_status=404

getActorPass
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${actor_data}=    Create Dictionary    name=Leo DiCaprio    actorId=LD1
    ${movie_data1}=    Create Dictionary    name=The Revenant    movieId=TRVN1
    ${movie_data2}=    Create Dictionary    name=The Wolf of Wall Street    movieId=TWOWS1



    ${actor_resp}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_data}    headers=${headers}    expected_status=200
    ${movie_resp1}=    PUT On Session    localhost    /api/v1/addMovie    json=${movie_data1}    headers=${headers}    expected_status=200
    ${movie_resp2}=    PUT On Session    localhost    /api/v1/addMovie    json=${movie_data2}    headers=${headers}    expected_status=200


    
    ${relationship_data1}=    Create Dictionary    actorId=LD1    movieId=TRVN1
    ${relationship_resp1}=    PUT On Session    localhost    /api/v1/addRelationship    json=${relationship_data1}    headers=${headers}    expected_status=200

    ${relationship_data2}=    Create Dictionary    actorId=LD1    movieId=TWOWS1
    ${relationship_resp2}=    PUT On Session    localhost    /api/v1/addRelationship    json=${relationship_data2}    headers=${headers}    expected_status=200

    ${actor_id}=    Set Variable    LD1
    ${resp}=    GET On Session    localhost    url=/api/v1/getActor?actorId=${actor_id}    headers=${headers}    expected_status=200

    

    Log To Console    ${resp.json()}

    ${actor_name}=    Set Variable    ${resp.json()['name']}
    ${movies_acted_in}=    Set Variable    ${resp.json()['movies']}
    
    Should Be Equal As Strings    ${actor_name}    Leo DiCaprio
    # ['what', 'is', 'this']
    Should Be Equal As Strings    ${movies_acted_in}    ['TRVN1', 'TWOWS1']
    Should Be Equal As Strings    ${actor_id}    LD1

getActorFail
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${actor_data}=    Create Dictionary    name=Leo DiCaprio    actorId=LD1

    ${actor_resp}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_data}    headers=${headers}    expected_status=200

    ${actor_id}=    Set Variable    LD2
    ${resp}=    GET On Session    localhost    url=/api/v1/getActor?actorId=${actor_id}    headers=${headers}    expected_status=404

getMoviePass
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${movie_data}=    Create Dictionary    name=Oppenheimer    movieId=OP1
    ${movie_resp}=    PUT On Session    localhost    /api/v1/addMovie    json=${movie_data}    headers=${headers}    expected_status=200
    
    ${actor_data1}=    Create Dictionary    name=Cillian Murphy    actorId=CM1
    ${actor_data2}=    Create Dictionary    name=Rami Malek    actorId=RM1
    
    ${actor_resp1}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_data1}    headers=${headers}    expected_status=200
    ${actor_resp1}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_data2}    headers=${headers}    expected_status=200

    ${relationship_data1}=    Create Dictionary    actorId=CM1    movieId=OP1
    ${relationship_resp1}=    PUT On Session    localhost    /api/v1/addRelationship    json=${relationship_data1}    headers=${headers}    expected_status=200

    ${relationship_data2}=    Create Dictionary    actorId=RM1    movieId=OP1
    ${relationship_resp2}=    PUT On Session    localhost    /api/v1/addRelationship    json=${relationship_data2}    headers=${headers}    expected_status=200

    
    ${movie_id}=    Set Variable    OP1
    ${resp}=    GET On Session    localhost    url=/api/v1/getMovie?movieId=${movie_id}    headers=${headers}    expected_status=200
    
    Log To Console    ${resp.json()}

    ${movie_name}=    Set Variable    ${resp.json()['name']}
    ${movie_id}=    Set Variable    ${resp.json()['movieId']}
    ${movie_actors}=    Set Variable    ${resp.json()['actors']}



    Should Be Equal As Strings    ${movie_name}    Oppenheimer
    Should Be Equal As Strings    ${movie_id}    OP1
    Should Be Equal As Strings    ${movie_actors}    ['CM1', 'RM1']

getMovieFail
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${movie_data}=    Create Dictionary    name=Oppenheimer    movieId=OP1
    ${movie_resp}=    PUT On Session    localhost    /api/v1/addMovie    json=${movie_data}    headers=${headers}    expected_status=200
    
    ${actor_data1}=    Create Dictionary    name=Cillian Murphy    actorId=CM1
    ${actor_data2}=    Create Dictionary    name=Rami Malek    actorId=RM1
    
    ${actor_resp1}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_data1}    headers=${headers}    expected_status=200
    ${actor_resp1}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_data2}    headers=${headers}    expected_status=200

    ${relationship_data1}=    Create Dictionary    actorId=CM1    movieId=OP1
    ${relationship_resp1}=    PUT On Session    localhost    /api/v1/addRelationship    json=${relationship_data1}    headers=${headers}    expected_status=200

    ${relationship_data2}=    Create Dictionary    actorId=RM1    movieId=OP1
    ${relationship_resp2}=    PUT On Session    localhost    /api/v1/addRelationship    json=${relationship_data2}    headers=${headers}    expected_status=200

    
    ${movie_id}=    Set Variable    OP11
    ${resp}=    GET On Session    localhost    url=/api/v1/getMovie?movieId=${movie_id}    headers=${headers}    expected_status=404

hasRelationshipPass
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${actor_data}=    Create Dictionary    name=Leo DiCaprio    actorId=LDC1
    ${movie_data}=    Create Dictionary    name=The Revenant    movieId=TRVN1


    ${actor_resp}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_data}    headers=${headers}    expected_status=200
    ${movie_resp}=    PUT On Session    localhost    /api/v1/addMovie    json=${movie_data}    headers=${headers}    expected_status=200

    ${relationship_data}=    Create Dictionary    actorId=LDC1    movieId=TRVN1
    
    ${relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${relationship_data}    headers=${headers}    expected_status=200

    ${actor_id}=    Set Variable    LDC1
    ${movie_id}=    Set Variable    TRVN1



    ${hasRelationship_resp}=    GET On Session    localhost    url=/api/v1/hasRelationship?actorId=${actor_id}&movieId=${movie_id}    headers=${headers}    expected_status=200

    ${actor_id_resp}=    Set Variable    ${hasRelationship_resp.json()['actorId']}
    ${movie_id_resp}=    Set Variable    ${hasRelationship_resp.json()['movieId']}
    ${hasRelationship_bool}=    Set Variable    ${hasRelationship_resp.json()['hasRelationship']}

    Should Be Equal As Strings    ${actor_id_resp}    LDC1
    Should Be Equal As Strings    ${movie_id_resp}    TRVN1
    Should Be Equal As Strings    ${hasRelationship_bool}    true

hasRelationshipFail
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${actor_data}=    Create Dictionary    name=Leo DiCaprio    actorId=LDC1
    ${movie_data}=    Create Dictionary    name=The Revenant    movieId=TRVN1


    ${actor_resp}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_data}    headers=${headers}    expected_status=200
    ${movie_resp}=    PUT On Session    localhost    /api/v1/addMovie    json=${movie_data}    headers=${headers}    expected_status=200

    ${relationship_data}=    Create Dictionary    actorId=LDC1    movieId=TRVN1
    
    ${relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${relationship_data}    headers=${headers}    expected_status=200

    ${actor_id}=    Set Variable    LDC1
    ${movie_id}=    Set Variable    TRVN1



    ${hasRelationship_resp}=    GET On Session    localhost    url=/api/v1/hasRelationship?actorId=${movie_id}&movieId=${actor_id}    headers=${headers}    expected_status=404

computeBaconNumberPass
    ${headers}=    Create Dictionary    Content-Type=application/json

    ${actor_kevin_bacon}=    Create Dictionary    name=Kevin Bacon    actorId=nm0000102
    ${actor_keanu_reeves}=    Create Dictionary    name=Keanu Reeves    actorId=KR1
    ${actor_al_pacino}=    Create Dictionary    name=Al Pacino    actorId=AP1
    ${actor_hugo_weaving}=    Create Dictionary    name=Hugo Weaving    actorId=HW1


    ${actor_kevin_bacon_resp}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_kevin_bacon}    headers=${headers}    expected_status=200
    ${actor_keanu_reeves_resp}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_keanu_reeves}    headers=${headers}    expected_status=200
    ${actor_al_pacino_resp}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_al_pacino}    headers=${headers}    expected_status=200
    ${actor_hugo_weaving_resp}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_hugo_weaving}    headers=${headers}    expected_status=200

    ${movie_few_good_men}=    Create Dictionary    name=A Few Good Men    movieId=TFGB1
    ${movie_the_devils_advocate}=    Create Dictionary    name=The Devil's Advocate    movieId=TDAT1
    ${movie_the_matrix}=    Create Dictionary    name=The Matrix    movieId=MTRX1

    ${movie_few_good_men_resp}=    PUT On Session    localhost    /api/v1/addMovie    json=${movie_few_good_men}    headers=${headers}    expected_status=200
    ${movie_the_devils_advocate_resp}=    PUT On Session    localhost    /api/v1/addMovie    json=${movie_the_devils_advocate}    headers=${headers}    expected_status=200
    ${movie_the_matrix_resp}=    PUT On Session    localhost    /api/v1/addMovie    json=${movie_the_matrix}    headers=${headers}    expected_status=200


    ${kevin_bacon_few_good_men_relationship_data}=    Create Dictionary    actorId=nm0000102    movieId=TFGB1
    ${al_pacino_few_good_men_relationship_data}=    Create Dictionary    actorId=AP1    movieId=TFGB1
    ${al_pacino_the_devils_advocate_relationship_data}=    Create Dictionary    actorId=AP1    movieId=TDAT1
    ${keanu_reeves_the_devils_advocate_relationship_data}=    Create Dictionary    actorId=KR1    movieId=TDAT1
    ${keanu_reeves_the_matrix_relationship_data}=    Create Dictionary    actorId=KR1    movieId=MTRX1
    ${hugo_weaving_the_matrix_relationship_data}=    Create Dictionary    actorId=HW1    movieId=MTRX1



    ${kevin_bacon_few_good_men_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${kevin_bacon_few_good_men_relationship_data}    headers=${headers}    expected_status=200
    ${al_pacino_few_good_men_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${al_pacino_few_good_men_relationship_data}    headers=${headers}    expected_status=200
    ${al_pacino_the_devils_advocate_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${al_pacino_the_devils_advocate_relationship_data}    headers=${headers}    expected_status=200
    ${keanu_reeves_the_devils_advocate_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${keanu_reeves_the_devils_advocate_relationship_data}    headers=${headers}    expected_status=200
    ${keanu_reeves_the_matrix_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${keanu_reeves_the_matrix_relationship_data}    headers=${headers}    expected_status=200
    ${hugo_weaving_the_matrix_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${hugo_weaving_the_matrix_relationship_data}    headers=${headers}    expected_status=200


    ${hugo_weaving_actor_id}=    Set Variable    HW1

    ${compute_bacon_number_resp}=    GET On Session    localhost    url=/api/v1/computeBaconNumber?actorId=${hugo_weaving_actor_id}    headers=${headers}    expected_status=200

    ${bacon_number}=    Set Variable    ${compute_bacon_number_resp.json()['baconNumber']}

    Should Be Equal As Integers    ${bacon_number}    3

computeBaconNumberFail
    ${headers}=    Create Dictionary    Content-Type=application/json

    ${actor_kevin_bacon}=    Create Dictionary    name=Kevin Bacon    actorId=nm0000102
    ${actor_keanu_reeves}=    Create Dictionary    name=Keanu Reeves    actorId=KR1
    ${actor_al_pacino}=    Create Dictionary    name=Al Pacino    actorId=AP1
    ${actor_hugo_weaving}=    Create Dictionary    name=Hugo Weaving    actorId=HW1


    ${actor_kevin_bacon_resp}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_kevin_bacon}    headers=${headers}    expected_status=200
    ${actor_keanu_reeves_resp}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_keanu_reeves}    headers=${headers}    expected_status=200
    ${actor_al_pacino_resp}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_al_pacino}    headers=${headers}    expected_status=200
    ${actor_hugo_weaving_resp}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_hugo_weaving}    headers=${headers}    expected_status=200

    ${movie_few_good_men}=    Create Dictionary    name=A Few Good Men    movieId=TFGB1
    ${movie_the_devils_advocate}=    Create Dictionary    name=The Devil's Advocate    movieId=TDAT1
    ${movie_the_matrix}=    Create Dictionary    name=The Matrix    movieId=MTRX1

    ${movie_few_good_men_resp}=    PUT On Session    localhost    /api/v1/addMovie    json=${movie_few_good_men}    headers=${headers}    expected_status=200
    ${movie_the_devils_advocate_resp}=    PUT On Session    localhost    /api/v1/addMovie    json=${movie_the_devils_advocate}    headers=${headers}    expected_status=200
    ${movie_the_matrix_resp}=    PUT On Session    localhost    /api/v1/addMovie    json=${movie_the_matrix}    headers=${headers}    expected_status=200


    ${kevin_bacon_few_good_men_relationship_data}=    Create Dictionary    actorId=nm0000102    movieId=TFGB1
    ${al_pacino_few_good_men_relationship_data}=    Create Dictionary    actorId=AP1    movieId=TFGB1
    ${al_pacino_the_devils_advocate_relationship_data}=    Create Dictionary    actorId=AP1    movieId=TDAT1
    ${keanu_reeves_the_devils_advocate_relationship_data}=    Create Dictionary    actorId=KR1    movieId=TDAT1
    ${keanu_reeves_the_matrix_relationship_data}=    Create Dictionary    actorId=KR1    movieId=MTRX1
    ${hugo_weaving_the_matrix_relationship_data}=    Create Dictionary    actorId=HW1    movieId=MTRX1



    ${kevin_bacon_few_good_men_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${kevin_bacon_few_good_men_relationship_data}    headers=${headers}    expected_status=200
    ${al_pacino_few_good_men_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${al_pacino_few_good_men_relationship_data}    headers=${headers}    expected_status=200
    ${al_pacino_the_devils_advocate_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${al_pacino_the_devils_advocate_relationship_data}    headers=${headers}    expected_status=200
    ${keanu_reeves_the_devils_advocate_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${keanu_reeves_the_devils_advocate_relationship_data}    headers=${headers}    expected_status=200
    ${keanu_reeves_the_matrix_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${keanu_reeves_the_matrix_relationship_data}    headers=${headers}    expected_status=200
    ${hugo_weaving_the_matrix_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${hugo_weaving_the_matrix_relationship_data}    headers=${headers}    expected_status=200


    ${hugo_weaving_actor_id}=    Set Variable    HW11

    ${compute_bacon_number_resp}=    GET On Session    localhost    url=/api/v1/computeBaconNumber?actorId=${hugo_weaving_actor_id}    headers=${headers}    expected_status=404


computeBaconPathPass
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${actor_kevin_bacon}=    Create Dictionary    name=Kevin Bacon    actorId=nm0000102
    ${actor_keanu_reeves}=    Create Dictionary    name=Keanu Reeves    actorId=KR1
    ${actor_al_pacino}=    Create Dictionary    name=Al Pacino    actorId=AP1
    ${actor_hugo_weaving}=    Create Dictionary    name=Hugo Weaving    actorId=HW1


    ${actor_kevin_bacon_resp}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_kevin_bacon}    headers=${headers}    expected_status=200
    ${actor_keanu_reeves_resp}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_keanu_reeves}    headers=${headers}    expected_status=200
    ${actor_al_pacino_resp}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_al_pacino}    headers=${headers}    expected_status=200
    ${actor_hugo_weaving_resp}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_hugo_weaving}    headers=${headers}    expected_status=200

    ${movie_few_good_men}=    Create Dictionary    name=A Few Good Men    movieId=TFGB1
    ${movie_the_devils_advocate}=    Create Dictionary    name=The Devil's Advocate    movieId=TDAT1
    ${movie_the_matrix}=    Create Dictionary    name=The Matrix    movieId=MTRX1

    ${movie_few_good_men_resp}=    PUT On Session    localhost    /api/v1/addMovie    json=${movie_few_good_men}    headers=${headers}    expected_status=200
    ${movie_the_devils_advocate_resp}=    PUT On Session    localhost    /api/v1/addMovie    json=${movie_the_devils_advocate}    headers=${headers}    expected_status=200
    ${movie_the_matrix_resp}=    PUT On Session    localhost    /api/v1/addMovie    json=${movie_the_matrix}    headers=${headers}    expected_status=200


    ${kevin_bacon_few_good_men_relationship_data}=    Create Dictionary    actorId=nm0000102    movieId=TFGB1
    ${al_pacino_few_good_men_relationship_data}=    Create Dictionary    actorId=AP1    movieId=TFGB1
    ${al_pacino_the_devils_advocate_relationship_data}=    Create Dictionary    actorId=AP1    movieId=TDAT1
    ${keanu_reeves_the_devils_advocate_relationship_data}=    Create Dictionary    actorId=KR1    movieId=TDAT1
    ${keanu_reeves_the_matrix_relationship_data}=    Create Dictionary    actorId=KR1    movieId=MTRX1
    ${hugo_weaving_the_matrix_relationship_data}=    Create Dictionary    actorId=HW1    movieId=MTRX1



    ${kevin_bacon_few_good_men_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${kevin_bacon_few_good_men_relationship_data}    headers=${headers}    expected_status=200
    ${al_pacino_few_good_men_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${al_pacino_few_good_men_relationship_data}    headers=${headers}    expected_status=200
    ${al_pacino_the_devils_advocate_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${al_pacino_the_devils_advocate_relationship_data}    headers=${headers}    expected_status=200
    ${keanu_reeves_the_devils_advocate_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${keanu_reeves_the_devils_advocate_relationship_data}    headers=${headers}    expected_status=200
    ${keanu_reeves_the_matrix_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${keanu_reeves_the_matrix_relationship_data}    headers=${headers}    expected_status=200
    ${hugo_weaving_the_matrix_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${hugo_weaving_the_matrix_relationship_data}    headers=${headers}    expected_status=200

    ${hugo_weaving_actor_id}=    Set Variable    HW1
    
    ${compute_bacon_path_resp}=    GET On Session    localhost    url=/api/v1/computeBaconPath?actorId=${hugo_weaving_actor_id}    headers=${headers}    expected_status=200
    Log To Console    ${compute_bacon_path_resp.json()}


    ${bacon_path}=    Set Variable    ${compute_bacon_path_resp.json()['baconPath']}

    Should Be Equal As Strings    ${bacon_path}    ['HW1', 'MTRX1', 'KR1', 'TDAT1', 'AP1', 'TFGB1', 'nm0000102']

computeBaconPathFail
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${actor_kevin_bacon}=    Create Dictionary    name=Kevin Bacon    actorId=nm0000102
    ${actor_keanu_reeves}=    Create Dictionary    name=Keanu Reeves    actorId=KR1
    ${actor_al_pacino}=    Create Dictionary    name=Al Pacino    actorId=AP1
    ${actor_hugo_weaving}=    Create Dictionary    name=Hugo Weaving    actorId=HW1


    ${actor_kevin_bacon_resp}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_kevin_bacon}    headers=${headers}    expected_status=200
    ${actor_keanu_reeves_resp}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_keanu_reeves}    headers=${headers}    expected_status=200
    ${actor_al_pacino_resp}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_al_pacino}    headers=${headers}    expected_status=200
    ${actor_hugo_weaving_resp}=    PUT On Session    localhost    /api/v1/addActor    json=${actor_hugo_weaving}    headers=${headers}    expected_status=200

    ${movie_few_good_men}=    Create Dictionary    name=A Few Good Men    movieId=TFGB1
    ${movie_the_devils_advocate}=    Create Dictionary    name=The Devil's Advocate    movieId=TDAT1
    ${movie_the_matrix}=    Create Dictionary    name=The Matrix    movieId=MTRX1

    ${movie_few_good_men_resp}=    PUT On Session    localhost    /api/v1/addMovie    json=${movie_few_good_men}    headers=${headers}    expected_status=200
    ${movie_the_devils_advocate_resp}=    PUT On Session    localhost    /api/v1/addMovie    json=${movie_the_devils_advocate}    headers=${headers}    expected_status=200
    ${movie_the_matrix_resp}=    PUT On Session    localhost    /api/v1/addMovie    json=${movie_the_matrix}    headers=${headers}    expected_status=200


    ${kevin_bacon_few_good_men_relationship_data}=    Create Dictionary    actorId=nm0000102    movieId=TFGB1
    ${al_pacino_few_good_men_relationship_data}=    Create Dictionary    actorId=AP1    movieId=TFGB1
    ${al_pacino_the_devils_advocate_relationship_data}=    Create Dictionary    actorId=AP1    movieId=TDAT1
    ${keanu_reeves_the_devils_advocate_relationship_data}=    Create Dictionary    actorId=KR1    movieId=TDAT1
    ${keanu_reeves_the_matrix_relationship_data}=    Create Dictionary    actorId=KR1    movieId=MTRX1
    ${hugo_weaving_the_matrix_relationship_data}=    Create Dictionary    actorId=HW1    movieId=MTRX1



    ${kevin_bacon_few_good_men_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${kevin_bacon_few_good_men_relationship_data}    headers=${headers}    expected_status=200
    ${al_pacino_few_good_men_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${al_pacino_few_good_men_relationship_data}    headers=${headers}    expected_status=200
    ${al_pacino_the_devils_advocate_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${al_pacino_the_devils_advocate_relationship_data}    headers=${headers}    expected_status=200
    ${keanu_reeves_the_devils_advocate_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${keanu_reeves_the_devils_advocate_relationship_data}    headers=${headers}    expected_status=200
    ${keanu_reeves_the_matrix_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${keanu_reeves_the_matrix_relationship_data}    headers=${headers}    expected_status=200
    ${hugo_weaving_the_matrix_relationship_resp}=    PUT On Session    localhost    /api/v1/addRelationship    json=${hugo_weaving_the_matrix_relationship_data}    headers=${headers}    expected_status=200

    ${hugo_weaving_actor_id}=    Set Variable    HW11
    
    ${compute_bacon_path_resp}=    GET On Session    localhost    url=/api/v1/computeBaconPath?actorId=${hugo_weaving_actor_id}    headers=${headers}    expected_status=404
 





