import consumer from "channels/consumer"

const onlineUsers = document.getElementById('online_users');
// we only want to stream when this element appears in the dom
if(onlineUsers) {
  consumer.subscriptions.create("OnlineStatusChannel", {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
    }
});
}
