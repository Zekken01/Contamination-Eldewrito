; GLOBALS

(global string data_mine_mission_segment "")
(global boolean perspective_running false)
(global boolean perspective_finished false)
(global boolean g_cortana_header false)
(global boolean g_cortana_footer false)
(global boolean g_gravemind_header false)
(global boolean g_gravemind_footer false)
(global boolean ee1 false)
(global boolean ee2 false)
(global boolean ee3 false)
(global boolean bma false)
(global boolean can_double false)
(global boolean f_airborne false)
(global boolean nade_jump true)
(global string a0 "player0 used double jump - 'can_double' is false.")
(global string a1 "player0 is grounded - 'can_double' is true.")
(global string a2 "player0 is airborne.")
(global boolean cherry_on_top false)
(global boolean debug false)
(global short funny_weapon_number 0)
(global short enemies_spawned 0)
(global short lives 5)
(global long all_this_round 0)
(global long enemies_remaining 0)
(global long sq_default_total 0)
(global short sq_smg_total 0)
(global short sq_ar_total 0)
(global short sq_pr_total 0)
(global short sq_brutes_total 0)
(global short sq_br_total 0)
(global short sq_bruteshot_total 0)
(global short sq_shotgun_total 0)
(global short sq_tank_total 0)
(global short sq_carrier_total 0)
(global short sq_f_you_total 0)
(global short sq_default_left 0)
(global short sq_smg_left 0)
(global short sq_ar_left 0)
(global short sq_pr_left 0)
(global short sq_brutes_left 0)
(global short sq_br_left 0)
(global short sq_bruteshot_left 0)
(global short sq_shotgun_left 0)
(global short sq_tank_left 0)
(global short sq_carrier_left 0)
(global short sq_f_you_left 0)
(global long kills_this_round 0)
(global long kills_this_game 0)
(global short total_alive 9)
(global boolean count_restart false)
(global boolean sugar_cube false)
(global boolean sprinkles false)
(global boolean enable_main_wave false)
(global boolean main_round false)
(global boolean spawn_smgs false)
(global boolean spawn_ars false)
(global boolean spawn_prs false)
(global boolean spawn_brutes_n_squids false)
(global boolean spawn_br_n_carbine false)
(global boolean spawn_bruteshotters false)
(global boolean spawn_shotgunners false)
(global boolean spawn_tank false)
(global boolean spawn_carrier false)
(global boolean spawn_f_you false)
(global boolean endless_wave false)
(global boolean wallsstuff false)
(global short wall_knocks 0)
(global boolean held_punch false)
(global boolean jeff_sees_you false)
(global boolean debugging_jeff_co_op false)


; SCRIPTS

(script static unit player0
    (unit (list_get (players) 0))
)

(script static unit player1
    (unit (list_get (players) 1))
)

(script static unit player2
    (unit (list_get (players) 2))
)

(script static unit player3
    (unit (list_get (players) 3))
)

(script static void cinematic_snap_to_black
    (ai_disregard (players) true)
    (object_cannot_take_damage (players))
    (fade_out 0.0 0.0 0.0 0)
    (player_control_fade_out_all_input 0.0)
    (unit_lower_weapon (player0) 1)
    (unit_lower_weapon (player1) 1)
    (unit_lower_weapon (player2) 1)
    (unit_lower_weapon (player3) 1)
    (sleep 1)
    (object_hide (player0) true)
    (object_hide (player1) true)
    (object_hide (player2) true)
    (object_hide (player3) true)
    (chud_cinematic_fade 0.0 0.0)
    (campaign_metagame_time_pause true)
    (sleep 1)
    (cinematic_start)
    (camera_control true)
    (player_enable_input false)
    (player_disable_movement false)
    (sleep 1)
    (cinematic_show_letterbox_immediate true)
    (sleep 1)
)

(script static boolean f_melee_not_held
    (player_action_test_reset)
	(unit_action_test_reset (player_get 0))
    (not (unit_action_test_vision_trigger (player_get 0)))
)

(script static boolean f_melee_not_held_wall
    (player_action_test_reset)
    (not (player_action_test_melee))
)

(script static boolean f_nade_not_held
    (player_action_test_reset)
    (not (player_action_test_rotate_grenades))
)

(script static boolean f_weap_not_held
    (player_action_test_reset)
    (not (player_action_test_rotate_weapons))
)

(script continuous void confections
    (if 
        (and
            sugar_cube
            sprinkles
            cherry_on_top
        ) 
            (begin
                (lmao)
                (sleep_forever)
            )
    )
)

(script static void lmao
    (print "diabetes")
    (object_create "conf_1")
    (object_create "conf_2")
    (object_create "conf_3")
    (object_create "conf_4")
)

(script continuous void alive_check_treats
    (cond
        ((and
            (not sugar_cube)
            (< (object_get_health "sugar") 1.0)
        )
            (print "sugar dead lol")
            (set sugar_cube true)
            (confection_killer "sugar")
        )
        ((and
            (not sprinkles)
            (< (object_get_health "sprinkles_stuff") 1.0)
        )
            (print "sprinkles dead lol")
            (set sprinkles true)
            (confection_killer "sprinkles_stuff")
        )
        ((and
            (not cherry_on_top)
            (< (object_get_health "cherry") 1.0)
        )
            (print "cherry dead lol")
            (set cherry_on_top true)
            (confection_killer "cherry")
        )
    )
)

(script static void confection_killer (object conf)
    (effect_new_on_object_marker "\objects\characters\grunt\fx\grunt_birthday_party" conf "root")
    (object_destroy conf)
)

(script continuous void conf_safety1
    (if sugar_cube 
        (sleep_forever))
    (if 
        (or
            (objects_can_see_object (player0) "sugar" 1.0)
            (objects_can_see_object (player1) "sugar" 1.0)
            (objects_can_see_object (player2) "sugar" 1.0)
            (objects_can_see_object (player3) "sugar" 1.0)
        ) 
            (begin
                (print "sugar is mortal")
                (object_can_take_damage "sugar")
                (sleep_until (not (objects_can_see_object (player0) "sugar" 1.0)))
                (print "sugar is safe")
                (object_cannot_take_damage "sugar")
            )
    )
)

(script continuous void conf_safety2
    (if sprinkles 
        (sleep_forever))
    (if 
        (or
            (objects_can_see_object (player0) "sprinkles_stuff" 1.0)
            (objects_can_see_object (player1) "sprinkles_stuff" 1.0)
            (objects_can_see_object (player2) "sprinkles_stuff" 1.0)
            (objects_can_see_object (player3) "sprinkles_stuff" 1.0)
        ) 
            (begin
                (print "sprinkles are mortal")
                (object_can_take_damage "sprinkles_stuff")
                (sleep_until (not (objects_can_see_object (player0) "sprinkles_stuff" 1.0)))
                (print "sprinkles are safe")
                (object_cannot_take_damage "sprinkles_stuff")
            )
    )
)

(script continuous void conf_safety3
    (if cherry_on_top 
        (sleep_forever))
    (if 
        (or
            (objects_can_see_object (player0) "cherry" 1.0)
            (objects_can_see_object (player1) "cherry" 1.0)
            (objects_can_see_object (player2) "cherry" 1.0)
            (objects_can_see_object (player3) "cherry" 1.0)
        ) 
            (begin
                (print "cherry is mortal")
                (object_can_take_damage "cherry")
                (sleep_until (not (objects_can_see_object (player0) "cherry" 1.0)))
                (print "cherry is safe")
                (object_cannot_take_damage "cherry")
            )
    )
)

(script continuous void skull_safety1
    (if ee1 
        (sleep_until (not ee1)))
    (if 
        (or
            (objects_can_see_object (player0) "ee_song1" 3.0)
            (objects_can_see_object (player1) "ee_song1" 3.0)
            (objects_can_see_object (player2) "ee_song1" 3.0)
            (objects_can_see_object (player3) "ee_song1" 3.0)
        ) 
            (begin
                (print "ee1 is mortal")
                (object_can_take_damage "ee_song1")
                (sleep_until (not (objects_can_see_object (player0) "ee_song1" 3.0)))
                (print "ee1 is safe")
                (object_cannot_take_damage "ee_song1")
            )
    )
)

(script continuous void skull_safety2
    (if ee2 
        (sleep_until (not ee2)))
    (if 
        (or
            (objects_can_see_object (player0) "ee_song2" 3.0)
            (objects_can_see_object (player1) "ee_song2" 3.0)
            (objects_can_see_object (player2) "ee_song2" 3.0)
            (objects_can_see_object (player3) "ee_song2" 3.0)
        ) 
            (begin
                (print "ee2 is mortal")
                (object_can_take_damage "ee_song2")
                (sleep_until (not (objects_can_see_object (player0) "ee_song2" 3.0)))
                (print "ee2 is safe")
                (object_cannot_take_damage "ee_song2")
            )
    )
)

(script continuous void skull_safety3
    (if ee3 
        (sleep_until (not ee3)))
    (if 
        (or
            (objects_can_see_object (player0) "ee_song3" 3.0)
            (objects_can_see_object (player1) "ee_song3" 3.0)
            (objects_can_see_object (player2) "ee_song3" 3.0)
            (objects_can_see_object (player3) "ee_song3" 3.0)
        ) 
            (begin
                (print "ee1 is mortal")
                (object_can_take_damage "ee_song3")
                (sleep_until (not (objects_can_see_object (player0) "ee_song1" 3.0)))
                (print "ee1 is safe")
                (object_cannot_take_damage "ee_song3")
            )
    )
)

(script continuous void alive_check_skulls
    (cond
        ((and
            (not ee1)
            (< (object_get_health "ee_song1") 1.0)
        )
            (print "skull 1 dead lol")
            (set ee1 true)
            (confection_killer "ee_song1")
        )
        ((and
            (not ee2)
            (< (object_get_health "ee_song2") 1.0)
        )
            (print "skull 2 dead lol")
            (set ee2 true)
            (confection_killer "ee_song2")
        )
        ((and
            (not ee3)
            (< (object_get_health "ee_song3") 1.0)
        )
            (print "skull 3 dead lol")
            (set ee3 true)
            (confection_killer "ee_song3")
        )
    )
)

(script continuous void breaking_benjamin
    (if 
        (and
            ee1
            ee2
            ee3
        ) 
            (begin
                (print "music start?")
                (sound_looping_stop_immediately "levels\solo\070_waste\music\070_music_085")
                (sound_looping_stop_immediately "levels\solo\100_citadel\music\100_music_13")
                (sound_looping_stop_immediately "levels\solo\120_halo\music\120_music_09")
                (sound_looping_stop_immediately "levels\solo\050_floodvoi\music\050_music_02")
                (sound_looping_stop_immediately "levels\solo\050_floodvoi\music\050_music_03")
                (sound_impulse_start "levels\solo\containmentfbx\bma\blow me away.sound" none 1.0)
                (set bma true)
                (sleep 6150)
                (print "music stop?")
                (set bma false)
                (set ee1 false)
                (set ee2 false)
                (set ee3 false)
                (object_create_anew "ee_song1")
                (object_create_anew "ee_song2")
                (object_create_anew "ee_song3")
            )
    )
)

(script static boolean f_jump_not_held
    (player_action_test_reset)
    (not (player_action_test_jump))
)

(script continuous void ground_pound
    (sleep_until f_airborne 1)
    (sleep_until (f_melee_not_held) 1)
    (sleep_until (player_action_test_melee) 1)
    (if 
        (and
            (not can_double)
            f_airborne
            (not (game_is_cooperative))
        ) 
            (begin
                (object_set_velocity (player0) 3.08 0.0 3.08)
            )
    )
)

(script continuous void double_stuff
    (if (not f_airborne) 
        (begin
            (set can_double true)
        )
    )
)

(script continuous void debug_grounded_messages
    (if f_airborne 
        (begin
            (print a2)
            (sleep_until (not f_airborne))
            (print a1)
        )
    )
)

(script startup void start
    (cinematic_snap_to_black)
    (if debug 
        (print "debug lmao"))
    (game_safe_to_respawn true)
    (player_disable_movement true)
    (ai_enable false)
    (if (game_is_cooperative) 
        (begin
            (print "game is coop - jeff is checking his watch")
        ) (begin
            (print "game is singleplayer - jeff is counting knocks")
        )
    )
    (sound_looping_start "levels\solo\070_waste\music\070_music_085" none 1.0)
    (cinematic_fade_to_title)
    (cinematic_set_title "title")
    (cinematic_title_to_gameplay)
    (if (not debug) 
        (ai_enable true))
    (object_cannot_take_damage "sugar")
    (object_cannot_take_damage "sprinkles_stuff")
    (object_cannot_take_damage "cherry")
)

(script continuous void first_wave_complete
    (if (< (ai_nonswarm_count "default_baddies") 1) 
        (begin
            (set enable_main_wave true)
            (cinematic_set_chud_objective "obj_0")
            (sound_impulse_start "sound\dialog\110_hc\mission\110mx_300_grv" none 1.0)
            (sound_looping_stop "levels\solo\070_waste\music\070_music_085")
            (if (not bma) 
                (begin
                    (sound_impulse_start "sound\music\stingers\atoneswell3.sound" none 1.0)
                    (sound_impulse_start "sound\dialog\110_hc\mission\110mx_300_grv" none 1.0)
                    (sound_looping_start "levels\solo\100_citadel\music\100_music_13" none 1.0)
                )
            )
            (sleep_forever)
        )
    )
)

(script continuous void waves_enabling
    (if (> enemies_spawned 1) 
        (begin
            (set spawn_ars true)
            (wake debug_wave_msg1)
        )
    )
    (if (> enemies_spawned 2) 
        (begin
            (set spawn_smgs true)
            (wake debug_wave_msg2)
        )
    )
    (if (> enemies_spawned 3) 
        (begin
            (set spawn_prs true)
            (wake debug_wave_msg3)
        )
    )
    (if (> enemies_spawned 4) 
        (begin
            (set spawn_brutes_n_squids true)
            (wake debug_wave_msg4)
        )
    )
    (if (> enemies_spawned 5) 
        (begin
            (set spawn_br_n_carbine true)
            (wake debug_wave_msg5)
        )
    )
    (if (> enemies_spawned 6) 
        (begin
            (set spawn_shotgunners true)
            (wake debug_wave_msg6)
        )
    )
    (if (> enemies_spawned 7) 
        (begin
            (set spawn_bruteshotters true)
            (wake debug_wave_msg7)
        )
    )
    (if (> enemies_spawned 8) 
        (begin
            (set spawn_tank true)
            (wake debug_wave_msg8)
        )
    )
    (if (> enemies_spawned 9) 
        (begin
            (set spawn_carrier true)
            (wake debug_wave_msg9)
        )
    )
    (if (> enemies_spawned 10) 
        (begin
            (set spawn_f_you true)
            (wake debug_wave_msg10)
            (sleep_forever)
        )
    )
)

(script continuous void horderespawn_startwaves
    (if 
        (and
            (= enable_main_wave true)
            (= enemies_remaining 0)
        ) 
            (begin
                (ai_place "default_baddies_respawn")
                (set kills_this_round 0)
                (set all_this_round 0)
                (set enemies_spawned (+ enemies_spawned 1.0))
                (sleep 1)
                (set all_this_round (+ all_this_round (ai_nonswarm_count "default_baddies_respawn")))
                (set count_restart true)
                (set sq_default_left sq_default_total)
                (sleep 30)
                (if (= spawn_ars true) 
                    (begin
                        (ai_place "ars")
                        (sleep 1)
                        (set all_this_round (+ all_this_round (ai_nonswarm_count "ars")))
                    )
                )
                (sleep 1)
                (if (= spawn_smgs true) 
                    (begin
                        (ai_place "smgs")
                        (sleep 1)
                        (set all_this_round (+ all_this_round (ai_nonswarm_count "smgs")))
                    )
                )
                (sleep 1)
                (if (= spawn_prs true) 
                    (begin
                        (ai_place "prs")
                        (sleep 1)
                        (set all_this_round (+ all_this_round (ai_nonswarm_count "prs")))
                    )
                )
                (sleep 1)
                (if (= spawn_brutes_n_squids true) 
                    (begin
                        (ai_place "brutes_n_squids")
                        (sleep 1)
                        (set all_this_round (+ all_this_round (ai_nonswarm_count "brutes_n_squids")))
                    )
                )
                (sleep 1)
                (if (= spawn_tank true) 
                    (begin
                        (ai_place "tank")
                        (sleep 1)
                        (set all_this_round (+ all_this_round (ai_nonswarm_count "tank")))
                    )
                )
                (sleep 1)
                (if (= spawn_shotgunners true) 
                    (begin
                        (ai_place "shotgunners")
                        (sleep 1)
                        (set all_this_round (+ all_this_round (ai_nonswarm_count "shotgunners")))
                    )
                )
                (sleep 1)
                (if (= spawn_bruteshotters true) 
                    (begin
                        (ai_place "bruteshotter")
                        (sleep 1)
                        (set all_this_round (+ all_this_round (ai_nonswarm_count "bruteshotter")))
                    )
                )
                (sleep 1)
                (if (= spawn_br_n_carbine true) 
                    (begin
                        (ai_place "br-carbine")
                        (sleep 1)
                        (set all_this_round (+ all_this_round (ai_nonswarm_count "br-carbine")))
                    )
                )
                (sleep 1)
                (if (= spawn_carrier true) 
                    (begin
                        (ai_place "carriers")
                        (sleep 1)
                        (set all_this_round (+ all_this_round (ai_nonswarm_count "carriers")))
                    )
                )
                (sleep 30)
                (set enemies_remaining all_this_round)
                (set count_restart false)
                (if (= spawn_f_you true) 
                    (begin
                        (ai_place "f_you")
                        (sleep 30)
                        (set endless_wave true)
                        (set enable_main_wave false)
                        (print "main waves are over. this is where the fun begins :)")
                        (sleep_forever horderespawn_startwaves)
                    )
                )
            )
    )
)

(script continuous void main_respawn
    (sleep_until endless_wave)
    (if (< (ai_nonswarm_count "default_baddies_respawn") 1) 
        (begin
            (ai_place "default_baddies_respawn")
            (print "respawning the main wave!")
        )
    )
)

(script continuous void ars_respawn
    (sleep_until endless_wave)
    (if (< (ai_nonswarm_count "ars") 1) 
        (begin
            (sleep 60)
            (ai_place "ars")
            (print "respawning the guys with the ars!")
        )
    )
)

(script continuous void smgs_respawn
    (sleep_until endless_wave)
    (if (< (ai_nonswarm_count "smgs") 1) 
        (begin
            (sleep 60)
            (ai_place "smgs")
            (print "respawning the guys with smgs!")
        )
    )
)

(script continuous void prs_respawn
    (sleep_until endless_wave)
    (if (< (ai_nonswarm_count "prs") 1) 
        (begin
            (sleep 60)
            (ai_place "prs")
            (print "respawning the guys with plasma rifles!")
        )
    )
)

(script continuous void brutes_respawn
    (sleep_until endless_wave)
    (if (< (ai_nonswarm_count "brutes_n_squids") 1) 
        (begin
            (sleep 60)
            (ai_place "brutes_n_squids")
            (print "respawning the brutes and squids creatures!")
        )
    )
)

(script continuous void tank_respawn
    (sleep_until endless_wave)
    (if (< (ai_nonswarm_count "tank") 1) 
        (begin
            (sleep 600)
            (ai_place "tank")
            (print "respawning the tank!")
        )
    )
)

(script continuous void shotgun_respawn
    (sleep_until endless_wave)
    (if (< (ai_nonswarm_count "shotgunners") 1) 
        (begin
            (sleep 600)
            (ai_place "shotgunners")
            (print "respawning the shotgun assholes!")
        )
    )
)

(script continuous void bruteshot_respawn
    (sleep_until endless_wave)
    (if (< (ai_nonswarm_count "bruteshotter") 1) 
        (begin
            (sleep 600)
            (ai_place "bruteshotter")
            (print "respawning the bruteshot-holding dudes!")
        )
    )
)

(script continuous void brc_respawn
    (sleep_until endless_wave)
    (if (< (ai_nonswarm_count "br-carbine") 1) 
        (begin
            (sleep 400)
            (ai_place "br-carbine")
            (print "respawning the guys with precision weapons!")
        )
    )
)

(script continuous void carrier_respawn
    (sleep_until endless_wave)
    (if (< (ai_nonswarm_count "carriers") 1) 
        (begin
            (sleep 800)
            (ai_place "carriers")
            (print "respawning the big explodey guys!")
        )
    )
)

(script continuous void f_you_respawn
    (sleep_until endless_wave)
    (if (< (ai_nonswarm_count "f_you") 1) 
        (begin
            (sleep 800)
            (ai_place "f_you")
            (print "i'm gonna spawn more rocket flood. f*** you.")
        )
    )
)

(script dormant void debug_wave_msg1
    (print "ar losers")
    (sound_looping_stop_immediately "levels\solo\100_citadel\music\100_music_13")
    (sound_looping_stop_immediately "levels\solo\120_halo\music\120_music_09")
    (cinematic_set_chud_objective "obj_1")
    (if (not bma) 
        (begin
            (sound_impulse_start "sound\music\stingers\atoneswell3.sound" none 1.0)
            (sound_looping_start "levels\solo\070_waste\music\070_music_085" none 1.0)
        )
    )
)

(script dormant void debug_wave_msg2
    (print "smg boys")
    (cinematic_set_chud_objective "obj_2")
    (if (not bma) 
        (sound_impulse_start "sound\music\stingers\atoneswell3.sound" none 1.0))
)

(script dormant void debug_wave_msg3
    (print "plasma boys")
    (cinematic_set_chud_objective "obj_3")
    (if (not bma) 
        (sound_impulse_start "sound\music\stingers\atoneswell3.sound" none 1.0))
)

(script dormant void debug_wave_msg4
    (print "spikey boys")
    (cinematic_set_chud_objective "obj_4")
    (if (not bma) 
        (sound_impulse_start "sound\music\stingers\atoneswell3.sound" none 1.0))
)

(script dormant void debug_wave_msg5
    (print "battle rifles 'n' carbines")
    (cinematic_set_chud_objective "obj_5")
    (if (not bma) 
        (sound_impulse_start "sound\music\stingers\atoneswell3.sound" none 1.0))
)

(script dormant void debug_wave_msg6
    (print "shotgunners")
    (cinematic_set_chud_objective "obj_6")
    (if (not bma) 
        (sound_impulse_start "sound\music\stingers\atoneswell3.sound" none 1.0))
)

(script dormant void debug_wave_msg7
    (print "bruteshotters")
    (cinematic_set_chud_objective "obj_7")
    (if (not bma) 
        (sound_impulse_start "sound\music\stingers\atoneswell3.sound" none 1.0))
)

(script dormant void debug_wave_msg8
    (print "shoot the shit outta the tank!")
    (cinematic_set_chud_objective "obj_8")
    (if (not bma) 
        (sound_impulse_start "sound\music\stingers\atoneswell3.sound" none 1.0))
)

(script dormant void debug_wave_msg9
    (print "carriers")
    (cinematic_set_chud_objective "obj_9")
    (sound_looping_stop "levels\solo\070_waste\music\070_music_085")
    (if (not bma) 
        (begin
            (sound_impulse_start "sound\music\stingers\atoneswell3.sound" none 1.0)
            (sound_looping_start "levels\solo\050_floodvoi\music\050_music_02" none 1.0)
        )
    )
)

(script dormant void debug_wave_msg10
    (print "f*** you")
    (cinematic_set_chud_objective "obj_10")
    (sound_looping_stop "levels\solo\050_floodvoi\music\050_music_02")
    (if (not bma) 
        (sound_looping_start "levels\solo\050_floodvoi\music\050_music_03" none 1.0))
)

(script continuous void kill_counting_default
    (sleep_until (not count_restart))
    (if (< (ai_nonswarm_count "default_baddies_respawn") sq_default_left) 
        (begin
            (set enemies_remaining (- enemies_remaining (- sq_default_left (ai_nonswarm_count "default_baddies_respawn"))))
            (set kills_this_round (+ kills_this_round (- sq_default_left (ai_nonswarm_count "default_baddies_respawn"))))
            (set kills_this_game (+ kills_this_game (- sq_default_left (ai_nonswarm_count "default_baddies_respawn"))))
            (set sq_default_left (ai_nonswarm_count "default_baddies_respawn"))
            (print "total killed this game")
            (print "total enemies left")
            (inspect (+ kills_this_game 0.0))
            (inspect (+ enemies_remaining 0.0))
            (print "(inspect (+ enemies_remaining 0))")
            (sleep 1)
        )
    )
)

(script continuous void kill_counting_smg
    (sleep_until (not count_restart))
    (if (< (ai_nonswarm_count "smgs") sq_smg_left) 
        (begin
            (print "+")
            (inspect (- sq_smg_left (ai_nonswarm_count "smgs")))
            (set enemies_remaining (- enemies_remaining (- sq_smg_left (ai_nonswarm_count "smgs"))))
            (set kills_this_round (+ kills_this_round (- sq_smg_left (ai_nonswarm_count "smgs"))))
            (set kills_this_game (+ kills_this_game (- sq_smg_left (ai_nonswarm_count "smgs"))))
            (set sq_smg_left (ai_nonswarm_count "smgs"))
            (print "total killed this round")
            (print "total enemies left")
            (sleep 1)
            (inspect (+ kills_this_game 0.0))
            (inspect (+ enemies_remaining 0.0))
            (display_count enemies_remaining)
        )
    )
)

(script continuous void kill_counting_ar
    (sleep_until (not count_restart))
    (if (< (ai_nonswarm_count "ars") sq_ar_left) 
        (begin
            (print "+")
            (set enemies_remaining (- enemies_remaining (- sq_ar_left (ai_nonswarm_count "ars"))))
            (set kills_this_round (+ kills_this_round (- sq_ar_left (ai_nonswarm_count "ars"))))
            (set kills_this_game (+ kills_this_game (- sq_ar_left (ai_nonswarm_count "ars"))))
            (set sq_ar_left (ai_nonswarm_count "ars"))
            (print "total killed this round")
            (print "total enemies left")
            (sleep 1)
            (inspect (+ kills_this_game 0.0))
            (print "(inspect (+ enemies_remaining 0))")
            (inspect (+ enemies_remaining 0.0))
            (display_count enemies_remaining)
        )
    )
)

(script continuous void kill_counting_pr
    (sleep_until (not count_restart))
    (if (< (ai_nonswarm_count "prs") sq_pr_left) 
        (begin
            (print "+")
            (display_count (- sq_pr_left (ai_nonswarm_count "prs")))
            (set enemies_remaining (- enemies_remaining (- sq_pr_left (ai_nonswarm_count "prs"))))
            (set kills_this_round (+ kills_this_round (- sq_pr_left (ai_nonswarm_count "prs"))))
            (set kills_this_game (+ kills_this_game (- sq_pr_left (ai_nonswarm_count "prs"))))
            (set sq_pr_left (ai_nonswarm_count "prs"))
            (print "total killed this round")
            (print "total enemies left")
            (sleep 1)
            (inspect (+ kills_this_game 0.0))
            (inspect (+ enemies_remaining 0.0))
            (display_count enemies_remaining)
        )
    )
)

(script continuous void kill_counting_brutes
    (sleep_until (not count_restart))
    (if (< (ai_nonswarm_count "brutes_n_squids") sq_brutes_left) 
        (begin
            (print "+")
            (display_count (- sq_brutes_left (ai_nonswarm_count "brutes_n_squids")))
            (set enemies_remaining (- enemies_remaining (- sq_brutes_left (ai_nonswarm_count "brutes_n_squids"))))
            (set kills_this_round (+ kills_this_round (- sq_brutes_left (ai_nonswarm_count "brutes_n_squids"))))
            (set kills_this_game (+ kills_this_game (- sq_brutes_left (ai_nonswarm_count "brutes_n_squids"))))
            (set sq_brutes_left (ai_nonswarm_count "brutes_n_squids"))
            (print "total killed this round")
            (print "total enemies left")
            (sleep 1)
            (inspect (+ kills_this_game 0.0))
            (inspect (+ enemies_remaining 0.0))
            (display_count enemies_remaining)
        )
    )
)

(script continuous void kill_counting_br
    (sleep_until (not count_restart))
    (if (< (ai_nonswarm_count "br-carbine") sq_br_left) 
        (begin
            (print "+")
            (display_count (- sq_br_left (ai_nonswarm_count "br-carbine")))
            (set enemies_remaining (- enemies_remaining (- sq_br_left (ai_nonswarm_count "br-carbine"))))
            (set kills_this_round (+ kills_this_round (- sq_br_left (ai_nonswarm_count "br-carbine"))))
            (set kills_this_game (+ kills_this_game (- sq_br_left (ai_nonswarm_count "br-carbine"))))
            (set sq_br_left (ai_nonswarm_count "br-carbine"))
            (print "total killed this round")
            (print "total enemies left")
            (sleep 1)
            (inspect (+ kills_this_game 0.0))
            (inspect (+ enemies_remaining 0.0))
            (display_count enemies_remaining)
        )
    )
)

(script continuous void kill_counting_shotgun
    (sleep_until (not count_restart))
    (if (< (ai_nonswarm_count "shotgunners") sq_shotgun_left) 
        (begin
            (print "+")
            (display_count (- sq_shotgun_left (ai_nonswarm_count "shotgunners")))
            (set enemies_remaining (- enemies_remaining (- sq_shotgun_left (ai_nonswarm_count "shotgunners"))))
            (set kills_this_round (+ kills_this_round (- sq_shotgun_left (ai_nonswarm_count "shotgunners"))))
            (set kills_this_game (+ kills_this_game (- sq_shotgun_left (ai_nonswarm_count "shotgunners"))))
            (set sq_shotgun_left (ai_nonswarm_count "shotgunners"))
            (print "total killed this round")
            (print "total enemies left")
            (sleep 1)
            (inspect (+ kills_this_game 0.0))
            (inspect (+ enemies_remaining 0.0))
            (display_count enemies_remaining)
        )
    )
)

(script continuous void kill_counting_tank
    (sleep_until (not count_restart))
    (if (< (ai_nonswarm_count "tank") sq_tank_left) 
        (begin
            (print "+")
            (display_count (- sq_tank_left (ai_nonswarm_count "tank")))
            (set enemies_remaining (- enemies_remaining (- sq_tank_left (ai_nonswarm_count "tank"))))
            (set kills_this_round (+ kills_this_round (- sq_tank_left (ai_nonswarm_count "tank"))))
            (set kills_this_game (+ kills_this_game (- sq_tank_left (ai_nonswarm_count "tank"))))
            (set sq_tank_left (ai_nonswarm_count "tank"))
            (print "total killed this round")
            (print "total enemies left")
            (sleep 1)
            (inspect (+ kills_this_game 0.0))
            (inspect (+ enemies_remaining 0.0))
            (display_count enemies_remaining)
        )
    )
)

(script continuous void kill_counting_bruteshot
    (sleep_until (not count_restart))
    (if (< (ai_nonswarm_count "bruteshotter") sq_bruteshot_left) 
        (begin
            (print "+")
            (display_count (- sq_bruteshot_left (ai_nonswarm_count "bruteshotter")))
            (set enemies_remaining (- enemies_remaining (- sq_bruteshot_left (ai_nonswarm_count "bruteshotter"))))
            (set kills_this_round (+ kills_this_round (- sq_bruteshot_left (ai_nonswarm_count "bruteshotter"))))
            (set kills_this_game (+ kills_this_game (- sq_bruteshot_left (ai_nonswarm_count "bruteshotter"))))
            (set sq_bruteshot_left (ai_nonswarm_count "bruteshotter"))
            (print "total killed this round")
            (print "total enemies left")
            (sleep 1)
            (inspect (+ kills_this_game 0.0))
            (inspect (+ enemies_remaining 0.0))
        )
    )
)

(script continuous void kill_counting_carrier
    (sleep_until (not count_restart))
    (if (< (ai_nonswarm_count "carriers") sq_carrier_left) 
        (begin
            (print "+")
            (display_count (- sq_carrier_left (ai_nonswarm_count "carriers")))
            (set enemies_remaining (- enemies_remaining (- sq_carrier_left (ai_nonswarm_count "carriers"))))
            (set kills_this_round (+ kills_this_round (- sq_carrier_left (ai_nonswarm_count "carriers"))))
            (set kills_this_game (+ kills_this_game (- sq_carrier_left (ai_nonswarm_count "carriers"))))
            (set sq_carrier_left (ai_nonswarm_count "carriers"))
            (print "total killed this round")
            (print "total enemies left")
            (sleep 1)
            (inspect (+ kills_this_game 0.0))
            (inspect (+ enemies_remaining 0.0))
        )
    )
)

(script continuous void kill_counting_f_you
    (sleep_until (not count_restart))
    (if (< (ai_nonswarm_count "f_you") sq_f_you_left) 
        (begin
            (print "+")
            (display_count (- sq_f_you_left (ai_nonswarm_count "f_you")))
            (set enemies_remaining (- enemies_remaining (- sq_f_you_left (ai_nonswarm_count "f_you"))))
            (set kills_this_round (+ kills_this_round (- sq_f_you_left (ai_nonswarm_count "f_you"))))
            (set kills_this_game (+ kills_this_game (- sq_f_you_left (ai_nonswarm_count "f_you"))))
            (set sq_f_you_left (ai_nonswarm_count "f_you"))
            (print "total killed this round")
            (print "total enemies left")
            (sleep 1)
            (inspect (+ kills_this_game 0.0))
            (inspect (+ enemies_remaining 0.0))
            (print "(gey)")
            (display_count enemies_remaining)
        )
    )
)

(script static void gey
    (inspect (+ enemies_remaining 0.0))
)

(script static void display_count (long kc)
    (cond
        ((= kc 1)
            (print "1")
        )
        ((= kc 2)
            (print "2")
        )
        ((= kc 3)
            (print "3")
        )
        ((= kc 4)
            (print "4")
        )
        ((= kc 5)
            (print "5")
        )
        ((= kc 6)
            (print "6")
        )
        ((= kc 7)
            (print "7")
        )
        ((= kc 8)
            (print "8")
        )
        ((= kc 9)
            (print "9")
        )
        ((= kc 10)
            (print "10")
        )
        ((= kc 11)
            (print "11")
        )
        ((= kc 12)
            (print "12")
        )
        ((= kc 13)
            (print "13")
        )
        ((= kc 14)
            (print "14")
        )
        ((= kc 15)
            (print "15")
        )
        ((= kc 16)
            (print "16")
        )
        ((= kc 17)
            (print "17")
        )
        ((= kc 18)
            (print "18")
        )
        ((= kc 19)
            (print "19")
        )
        ((= kc 20)
            (print "20")
        )
        ((= kc 21)
            (print "21")
        )
        ((= kc 22)
            (print "22")
        )
        ((= kc 23)
            (print "23")
        )
        ((= kc 24)
            (print "24")
        )
        ((= kc 25)
            (print "25")
        )
        ((= kc 26)
            (print "26")
        )
        ((= kc 27)
            (print "27")
        )
        ((= kc 28)
            (print "28")
        )
        ((= kc 29)
            (print "29")
        )
        ((= kc 30)
            (print "30")
        )
    )
)

(script continuous void kc_patch
    (cond
        ((> (ai_nonswarm_count "default_baddies_respawn") sq_default_left)
            (begin
                (set sq_default_left (ai_nonswarm_count "default_baddies_respawn"))
            )
        )
        ((> (ai_nonswarm_count "smgs") sq_smg_left)
            (begin
                (set sq_smg_left (ai_nonswarm_count "smgs"))
            )
        )
        ((> (ai_nonswarm_count "ars") sq_ar_left)
            (begin
                (set sq_ar_left (ai_nonswarm_count "ars"))
            )
        )
        ((> (ai_nonswarm_count "prs") sq_pr_left)
            (begin
                (set sq_pr_left (ai_nonswarm_count "prs"))
            )
        )
        ((> (ai_nonswarm_count "brutes_n_squids") sq_brutes_left)
            (begin
                (set sq_brutes_left (ai_nonswarm_count "brutes_n_squids"))
            )
        )
        ((> (ai_nonswarm_count "br-carbine") sq_br_left)
            (begin
                (set sq_br_left (ai_nonswarm_count "br-carbine"))
            )
        )
        ((> (ai_nonswarm_count "shotgunners") sq_shotgun_left)
            (begin
                (set sq_shotgun_left (ai_nonswarm_count "shotgunners"))
            )
        )
        ((> (ai_nonswarm_count "tank") sq_tank_left)
            (begin
                (set sq_tank_left (ai_nonswarm_count "tank"))
            )
        )
        ((> (ai_nonswarm_count "bruteshotter") sq_bruteshot_left)
            (begin
                (set sq_bruteshot_left (ai_nonswarm_count "bruteshotter"))
            )
        )
        ((> (ai_nonswarm_count "carriers") sq_carrier_left)
            (begin
                (set sq_carrier_left (ai_nonswarm_count "carriers"))
            )
        )
        ((> (ai_nonswarm_count "f_you") sq_f_you_left)
            (begin
                (set sq_f_you_left (ai_nonswarm_count "f_you"))
            )
        )
    )
)

(script continuous void walls_volume_check
    (cond
        ((not jeff_sees_you)
            (if (volume_test_players "walls") 
                (begin
                    (set jeff_sees_you true)
                    (if (not wallsstuff) 
                        (print "jeff can see you...") (print "you can hear him scurrying around in there..."))
                )
            )
        )
        (jeff_sees_you
            (if (not (volume_test_players "walls")) 
                (begin
                    (set jeff_sees_you false)
                    (print "reset")
                    (set wall_knocks 0)
                )
            )
        )
    )
)

(script continuous void walls
    (cond
        ((or
            (game_is_cooperative)
            debugging_jeff_co_op
        )
            (begin
                (sleep_until jeff_sees_you)
                (sleep 60)
                (if 
                    (and
                        jeff_sees_you
                        (not wallsstuff)
                    ) 
                        (begin
                            (set wall_knocks (+ wall_knocks 1.0))
                            (knocks wall_knocks)
                        )
                )
            )
        )
        ((not (game_is_cooperative))
            (begin
                (sleep_until (volume_test_players "walls") 1)
                (sleep_until (f_melee_not_held_wall) 1)
                (set held_punch false)
                (sleep_until (player_action_test_melee) 1)
                (if 
                    (and
                        (not wallsstuff)
                        (not held_punch)
                        jeff_sees_you
                        (objects_can_see_object (player0) "look_marker" 30.0)
                    ) 
                        (begin
                            (set wall_knocks (+ wall_knocks 1.0))
                            (knocks wall_knocks)
                            (sleep 26)
                        )
                )
            )
        )
    )
)

(script static void knocks (short fucking_knocking)
    (cond
        ((= fucking_knocking 1)
            (begin
                (print "1")
            )
        )
        ((= fucking_knocking 2)
            (begin
                (print "2")
            )
        )
        ((= fucking_knocking 3)
            (begin
                (print "3")
            )
        )
        ((> fucking_knocking 3)
            (begin
                (print "boop")
                (sleep 60)
                (if (volume_test_players "walls") 
                    (begin
                        (sound_impulse_start "levels\solo\containmentfbx\sounds\livinginsideyourwallsmuffled.sound" none 1.0)
                        (set wallsstuff true)
                    )
                )
            )
        )
    )
)

