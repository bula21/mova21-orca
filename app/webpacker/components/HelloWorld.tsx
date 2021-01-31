import * as React from 'react'

interface HelloWorldProps {
  greeting: string;
}

const HelloWorld: React.FC<HelloWorldProps> = ({ greeting }) => {
  return (
    <div>
      {greeting}
    </div>
  )
}

export default HelloWorld
