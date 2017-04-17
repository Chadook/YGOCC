--Created by Chadook
--Scripted By Chadook
--Onuri of of Magnificent Vine
function c500318989.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	
		--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetTargetRange(1,0)
	e0:SetTarget(c500318989.splimit)
	e0:SetCondition(c500318989.splimcon)
	c:RegisterEffect(e0)
	--Draw 1 Card for each Time you Xyz Summon a God damn monster!
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(500318989,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c500318989.condition)
	e2:SetCost(c500318989.cost)
	e2:SetTarget(c500318989.target)
	e2:SetOperation(c500318989.operation)
	c:RegisterEffect(e2)
		--unsynchroable
	local e666=Effect.CreateEffect(c)
	e666:SetType(EFFECT_TYPE_SINGLE)
	e666:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e666:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e666:SetCondition(c500318989.condition3)
	e666:SetValue(1)
	c:RegisterEffect(e666)
	--hey, This is why we need to recover Banished Cards.. :p {Wait, What ARE you doing here? Are you here to sneak on any Secrets?
	--Too Bad! There isn't any!}
	--Make Synchros Lose ATK!
	--Oh Wait!!! There isn't any... ;)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(785,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,500318989)
	e3:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e3:SetCost(c500318989.cost2)
	e3:SetTarget(c500318989.target2)
	e3:SetOperation(c500318989.operation2)
	c:RegisterEffect(e3)
	
end
function c500318989.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x785c)  then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c500318989.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c500318989.filter(c,tp)
	return c:IsSetCard(0x785c) and c:IsControler(tp) and c:GetSummonType()==SUMMON_TYPE_XYZ
end
function c500318989.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c500318989.filter,1,nil,tp)
end
function c500318989.cost(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c500318989.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
	function c500318989.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c500318989.condition3(e)
	return not e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function c500318989.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end



function c500318989.filter1(c,e,tp)
	local rk=c:GetRank()
	return rk>0 and c:IsFaceup()and c:IsSetCard(0x785c) and c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c500318989.filter2,tp,LOCATION_EXTRA,0,1,nil,rk+1,e,tp,c:GetCode())
	and not Duel.IsExistingMatchingCard(c500318989.filter3,tp,LOCATION_MZONE,0,1,nil,rk)
end
function c500318989.filter2(c,rk,e,tp,code)
    if c:IsCode(6165656) and code~=48995978 then return false end
	return (c:GetRank()==rk or c:GetRank()==rk+1) and c:IsSetCard(0x785c) and c:IsType(TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c500318989.filter3(c,rk)
	return c:IsFaceup() and c:IsSetCard(0x785c) and c:IsType(TYPE_XYZ) and c:GetRank()>rk
end
function c500318989.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c500318989.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c500318989.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c500318989.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c500318989.operation2(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c500318989.filter2,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetRank()+1,e,tp,tc:GetCode())
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end