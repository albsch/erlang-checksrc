# Usage

Arguments are valid erlang terms.
If dep tuple is provided, does not count exported functions if they have no
spec, but the spec is already specified in the dep behavior.
Multiple src and dep arguments are allowed.
Prints out useful list of functions yet to be type speced.

> ./check.erl "{src, 'folder-to-src'}." "{dep, 'folder-to-dep'}."


# Example output

`deps` contains Erlang standard library sources (`gen_server` etc.)


```
❯ ./check.erl "{dep, deps}." "{src, antidote}." "{dep, 'riak-core-src'}."
"{dep, deps}."
"{src, antidote}."
"{dep, 'riak-core-src'}."
"{dep, deps}."
"{src, antidote}."
"{dep, 'riak-core-src'}."
Dependencies: [deps,'riak-core-src']
Sources: [antidote]
Unspecced in "antidote/antidote_pb_sup.erl":
  * [ ] start_link/0
Unspecced in "antidote/antidote.erl":
  * [ ] create_bucket/2
  * [ ] create_object/3
  * [ ] delete_object/1
Unspecced in "antidote/zmq_context.erl":
  * [ ] start_link/0
  * [ ] get/0
Unspecced in "antidote/inter_dc_query_router.erl":
  * [ ] start_link/0
Unspecced in "antidote/clocksi_interactive_coord_sup.erl":
  * [ ] start_fsm/0
  * [ ] start_link/0
Unspecced in "antidote/inter_dc_sub_vnode.erl":
  * [ ] start_vnode/1
Unspecced in "antidote/materializer_vnode.erl":
  * [ ] start_vnode/1
Unspecced in "antidote/antidote_console.erl":
  * [ ] staged_join/1
  * [ ] down/1
  * [ ] ringready/1
Unspecced in "antidote/inter_dc_pub.erl":
  * [ ] start_link/0
Unspecced in "antidote/antidote_stats.erl":
  * [ ] start_link/0
Unspecced in "antidote/inter_dc_sup.erl":
  * [ ] start_link/0
Unspecced in "antidote/antidote_sup.erl":
  * [ ] start_link/0
Unspecced in "antidote/stable_time_functions.erl":
  * [ ] lookup/2
  * [ ] fold/3
  * [ ] store/3
  * [ ] default/0
  * [ ] initial_local/0
  * [ ] initial_merged/0
Unspecced in "antidote/antidote_hooks.erl":
  * [ ] get_hooks/2
  * [ ] test_commit_hook/1
  * [ ] test_increment_hook/1
  * [ ] test_post_hook/1
Unspecced in "antidote/antidote_app.erl":
  * [ ] start/2
  * [ ] stop/1
Unspecced in "antidote/clocksi_vnode.erl":
  * [ ] start_vnode/1
  * [ ] read_data_item/5
  * [ ] async_read_data_item/4
  * [ ] send_min_prepared/1
  * [ ] get_active_txns_key/2
  * [ ] prepare/2
  * [ ] commit/3
  * [ ] single_commit/2
  * [ ] single_commit_sync/2
  * [ ] abort/2
  * [ ] now_microsec/1
  * [ ] reverse_and_filter_updates_per_key/2
  * [ ] check_tables_ready/0
Unspecced in "antidote/zmq_utils.erl":
  * [ ] create_connect_socket/3
  * [ ] create_bind_socket/3
  * [ ] sub_filter/2
  * [ ] close_socket/1
Unspecced in "antidote/inter_dc_query_dealer.erl":
  * [ ] start_link/0
Unspecced in "antidote/antidote_pb_protocol.erl":
  * [ ] start_link/3
  * [ ] init/3
Unspecced in "antidote/inter_dc_sub.erl":
  * [ ] start_link/0
Unspecced in "antidote/antidote_error_monitor.erl":
  * [ ] log/2
Unspecced in "antidote/meta_data_sender_sup.erl":
  * [ ] start_fsm/1
  * [ ] start_link/1
Unspecced in "antidote/inter_dc_query_response.erl":
  * [ ] generate_server_name/1
Unspecced in "antidote/clocksi_interactive_coord.erl":
  * [ ] finish_op/3
  * [ ] stop/1
  * [ ] wait_for_start_transaction/3
  * [ ] receive_committed/3
  * [ ] receive_logging_responses/3
  * [ ] receive_read_objects_result/3
  * [ ] receive_aborted/3
  * [ ] receive_prepared/3
  * [ ] committing/3
  * [ ] committing_single/3
Unspecced in "antidote/meta_data_sender.erl":
  * [ ] send_meta_data/3
Unspecced in "antidote/antidote_ring_event_handler.erl":
  * [ ] update_status/0
Unspecced in "antidote/antidote_warning_monitor.erl":
  * [ ] log/2
Unspecced in "antidote/meta_data_manager_sup.erl":
  * [ ] start_fsm/1
  * [ ] start_link/1
Unspecced in "antidote/cure.erl":
  * [ ] get_objects/3
Unspecced in "antidote/bcounter_mgr.erl":
  * [ ] start_link/0
  * [ ] generate_downstream/3
  * [ ] process_transfer/1
  * [ ] request_response/1
Unspecced in "antidote/logging_vnode.erl":
  * [ ] handle_info/2
Unspecced in "antidote/inter_dc_log_sender_vnode.erl":
  * [ ] start_vnode/1
Unspecced in "antidote/inter_dc_utils.erl":
  * [ ] check_message_version/1
  * [ ] check_version_and_req_id/1
Unspecced in "antidote/inter_dc_query_response_sup.erl":
  * [ ] start_link/1
Unspecced in "antidote/stable_meta_data_server.erl":
  * [ ] generate_server_name/1
Unspecced in "antidote/inter_dc_dep_vnode.erl":
  * [ ] start_vnode/1
Exported: 491
Missing spec: 82
```
