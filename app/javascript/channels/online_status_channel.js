import consumer from "channels/consumer"

// const onlineUsers = document.getElementById('online_users');
// we only want to stream when this element appears in the dom
const onlineUsersRoom = document.getElementById('online_user_room_id');
const roomId = onlineUsersRoom?.getAttribute('roomId');
const userId = onlineUsersRoom?.getAttribute('userId');

if(onlineUsersRoom) {
  consumer.subscriptions.create({channel: "OnlineStatusChannel", room_id: roomId }, {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      let ele = document.getElementById(`online_status_${data['room_id']}_${data['current_user_id']}`);
      if(userId!==data['current_user_id']) {
          if(ele) {
            if(data['body'].match(/joined/)){
              ele.classList.remove('btn-default');
              ele.classList.add('btn-success');
              ele.innerText = 'online';
            }else if(data['body'].match(/left/)){
              ele.classList.remove('btn-success');
              ele.classList.add('btn-default');
              ele.innerText = 'offline';
            }
          }
      }
    }
  });
}