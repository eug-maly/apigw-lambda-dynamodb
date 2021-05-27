resource "aws_dynamodb_table" "words" {
  name           = "word"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "word"

  attribute {
    name = "word"
    type = "S"
  }

}

resource "aws_dynamodb_table_item" "items" {
  table_name = aws_dynamodb_table.words.name
  hash_key   = aws_dynamodb_table.words.hash_key

  for_each = {
    item1 = {
      word = "hello"
    }
    item2 = {
      word = "Bumblebee"
    }
    item3 = {
      word = "Ratchet"
    }
    item4 = {
      word = "Jetfire"
    }
    item5 = {
      word = "Wheeljack"
    }
    item6 = {
      word = "Oprimus"
    }
    item7 = {
      word = "Megatron"
    }
    item8 = {
      word = "Starscream"
    }
  }
  item = <<EOF
{
  "word": {"S": "${each.value.word}"}
}
EOF
}
