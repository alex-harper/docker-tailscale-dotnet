FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["TailscaleAndDotnet/TailscaleAndDotnet.csproj", "TailscaleAndDotnet/"]
RUN dotnet restore "TailscaleAndDotnet/TailscaleAndDotnet.csproj"
COPY . .
WORKDIR "/src/TailscaleAndDotnet"
RUN dotnet build "TailscaleAndDotnet.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TailscaleAndDotnet.csproj" -c Release -o /app/publish

FROM base AS tailscale
RUN apt update && apt install curl iputils-ping net-tools -y
RUN curl -fsSL https://tailscale.com/install.sh | sh

FROM tailscale AS final
WORKDIR /app
COPY --from=publish /app/publish .
RUN chmod +x ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]