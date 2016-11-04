
function c160008744.initial_effect(c)
c:EnableCounterPermit(0x1075)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e2:SetCondition(c160008744.ctcon)
	e2:SetOperation(c160008744.ctop)
	c:RegisterEffect(e2)
	-- local e3=e2:Clone()
	-- e3:SetCode(EVENT_REMOVE)
	-- c:RegisterEffect(e3)
	-- local e4=e2:Clone()
	-- e4:SetCode(EVENT_TO_DECK)
	-- c:RegisterEffect(e4)
		-- local e5=e2:Clone()
	-- e5:SetCode(EVENT_TO_HAND)
	-- c:RegisterEffect(e5)
		--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetValue(c160008744.atkval)
	c:RegisterEffect(e3)
		--disable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetCode(EFFECT_DISABLE)
	e6:SetTarget(c160008744.distg)
	c:RegisterEffect(e6)
		--Atk up

	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc50))
	e7:SetValue(600)
	c:RegisterEffect(e7)
	--Def down
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_SZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	e8:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc50))
	e8:SetValue(-300)
	c:RegisterEffect(e8)
	--to hand
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(160008744,0))
	e9:SetCategory(CATEGORY_DRAW)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetRange(LOCATION_SZONE)
	e9:SetCountLimit(1,160008744)
	e9:SetCost(c160008744.thcost)
	e9:SetTarget(c160008744.thtg)
	e9:SetOperation(c160008744.thop)
	c:RegisterEffect(e9)
	
end
function c160008744.cfilter(c)
	return  c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL) and c:IsType(TYPE_MONSTER)
end
function c160008744.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c160008744.cfilter,1,nil)
end
function c160008744.cfilter2(c)
	return  c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL) 
end
function c160008744.ctcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c160008744.cfilter2,1,nil)
end
function c160008744.ctop(e,tp,eg,ep,ev,re,r,rp)
	for i=1,5 do
		local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i-1)
		if tc and tc:IsCanAddCounter(0x1075,1) and not tc:IsSetCard(0xc50) and not tc:IsType(TYPE_NORMAL) then
			tc:AddCounter(0x1075,1)
		end
	end
	for i=1,5 do
		local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,i-1)
		if tc and tc:IsCanAddCounter(0x1075,1) and not tc:IsSetCard(0xc50) and not tc:IsType(TYPE_NORMAL) then
			tc:AddCounter(0x1075,1)
		end
	end
end
function c160008744.atkval(e,c)
	return c:GetCounter(0x1075)*-100
end



function c160008744.distg(e,c)
	return c:GetCounter(0x1075)>0  and not c:IsSetCard(0xc50) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c160008744.filter(e,c)
	return c:IsSetCard(0x1075)
end

function c160008744.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c160008744.hdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardHand(3-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
end
function c160008744.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,10,10,0x1075,10,REASON_COST) and Duel.GetCustomActivityCount(160008744,tp,ACTIVITY_SPSUMMON)==0 end 
	Duel.RemoveCounter(tp,10,10,0x1075,10,REASON_COST)
		local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c160008744.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c160008744.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end
function c160008744.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c160008744.thop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
