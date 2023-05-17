defmodule Newsletter do
  def read_emails(path) do
    
    file = File.read!(path)
    if file == "" do
      []
    else
      file
      |> String.trim()
      |> String.split("\n")
    end
  end

  def open_log(path) do
    File.open!(path, [:write])
  end

  def log_sent_email(pid, email) do
    IO.puts(pid, email)
  end

  def close_log(pid) do
    File.close(pid)
  end

  def send_newsletter(emails_path, log_path, send_fun) do
    log_pid = open_log(log_path)
    emails_path
    |> read_emails()
    |> Enum.map(fn email ->
      if send_fun.(email) == :ok do
        log_sent_email(log_pid, email)
      end
    end)
    close_log(log_pid)
  end
end
